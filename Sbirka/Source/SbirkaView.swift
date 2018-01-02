//
//  SbirkaView.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public enum UpdateContext {
    case normal
    case firstLoad
    case pagination
    case reload
    case syncLoad
}

public class SbirkaView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var registeredClass: [String: CollectionBaseCell.Type] = [:]
    private let updateQueue = DispatchQueue(label: "com.xuli.updateQueue", attributes: [])
    private let updateSemaphore = DispatchSemaphore(value: 1)
    
    var updateItemsCompleted: (() -> Void)?
    var items = [[BaseCellViewModel]]()
    weak var emptyProvider: SbirkaEmptyViewProvider?
    
    // MARK: init
    
    public init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

        commonInit()
    }
    
    public init(collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)

        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    public var cellType: CellsRegistrator? {
        didSet {
            cellType?.registerCells(view: self)
        }
    }
    
    private func commonInit() {
        backgroundColor = UIColor.clear
        
        delegate = self
        dataSource = self
    }
    
    // MARK: process changes
    
    public func update(items: [[BaseCellViewModel]], context: UpdateContext, callback: (() -> Void)? = nil) {
        updateModels(items, context: context) { [weak self] in
            self?.updateItemsCompleted?()
            callback?()
        }
    }
    
    private func updateModels(_ newItems: [[BaseCellViewModel]], context: UpdateContext, callback: @escaping () -> Void) {
        processItemsChanges(newItems, context: context, callback: { [weak self] (changes, newItems, completion: @escaping (() -> Void)) in
            if let strongSelf = self {
                let compl = {
                    completion()
                }
                strongSelf.updateItemsProcess(newItems, changes: changes, context: context) { [weak self] in
                    self?.checkShowEmpty()
                    callback()
                    compl()
                }
            }
        })
    }
    
    private func processItemsChanges(_ newItems: [[BaseCellViewModel]], context: UpdateContext, callback: @escaping (_: CollectionChanges, _: [[BaseCellViewModel]], _: @escaping () -> Void) -> Void) {
        let collectionViewWidth = getCollectionWidth()
        if context == .syncLoad {
            let changes = generateChangesFor(items: newItems, context: context, width: collectionViewWidth)
            callback(changes, newItems, {})
        } else {
            updateQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                _ = strongSelf.updateSemaphore.wait(timeout: DispatchTime.distantFuture)
                let changes = strongSelf.generateChangesFor(items: newItems, context: context, width: collectionViewWidth)
                DispatchQueue.main.async {
                    callback(changes, newItems, {
                        strongSelf.updateSemaphore.signal()
                    })
                }
            }
        }
    }
    
    private func generateChangesFor(items newItems: [[BaseCellViewModel]], context: UpdateContext, width: CGFloat) -> CollectionChanges {
        for section in newItems {
            for item in section {
                processVMLayout(item: item, width: width)
            }
        }
        let changes = context == .normal ? generateChanges(oldCollection: items, newCollection: newItems) : CollectionChanges.empty
        return changes
    }
    
    func updateItemsProcess(_ newItems: [[BaseCellViewModel]], changes: CollectionChanges, context: UpdateContext, callback: @escaping (() -> Void)) {
        
        let shouldScrollToBottom = needScrollToBottom(context)
        
        let visibleIndexPath = indexPathsForVisibleItems.sorted(by: { $0 < $1 })
        let oldIndexPath = visibleIndexPath.first
        let oldRect = self.rectAtIndexPath(oldIndexPath)
        let oldItemId: String? = oldIndexPath == nil ? nil : items[oldIndexPath!.section][oldIndexPath!.row].id
        let oldContentOffsetY = contentOffset.y
        
        let completion = {
            DispatchQueue.main.async {
                callback()
            }
        }
        self.items = newItems
        
        switch context {
        case .normal:
            UIView.animate(withDuration: 0.3, animations: {
                self.updateVisibleCells(changes)
                self.performBatchUpdates({
                    self.deleteItems(at: Array(changes.deletedIndexPaths) as [IndexPath])
                    self.insertItems(at: Array(changes.insertedIndexPaths) as [IndexPath])
                    for move in changes.movedIndexPaths {
                        self.moveItem(at: move.indexPathOld as IndexPath, to: move.indexPathNew as IndexPath)
                    }
                    self.insertSections(changes.insertedSections)
                    self.deleteSections(changes.deletedSections)
                }, completion: { _ -> Void in
                    completion()
                })
            })
        default:
            reloadData()
            collectionViewLayout.prepare()
            callback()
        }
        
        if shouldScrollToBottom {
            scrollToBottom(animated: context == .normal)
        } else {
            switch context {
            case .firstLoad, .syncLoad:
                break
            default:
                if let newOldIndexPath = indexPath(for: oldItemId) {
                    let newRect = self.rectAtIndexPath(newOldIndexPath)
                    self.scrollToPreservePosition(oldRefRect: oldRect, newRefRect: newRect, oldContentOffsetY: oldContentOffsetY)
                }
            }
        }
    }
    
    func updateVisibleCells(_ changes: CollectionChanges) {
        let visibleIndexPaths = Set(self.indexPathsForVisibleItems.filter { (indexPath) -> Bool in
            return !changes.insertedIndexPaths.contains(indexPath) && !changes.deletedIndexPaths.contains(indexPath)
        })
        
        var updatedIndexPaths = Set<IndexPath>()
        
        for move in changes.movedIndexPaths {
            updatedIndexPaths.insert(move.indexPathOld as IndexPath)
            if let cell = self.cellForItem(at: move.indexPathOld as IndexPath) as? CollectionBaseCell {
                let item = items[move.indexPathNew.section][move.indexPathNew.row]
                cell.configurate(item, visible: true, prototype: false)
            }
        }
        
        // Update remaining visible cells
        let remaining = visibleIndexPaths.subtracting(updatedIndexPaths)
        for indexPath in remaining {
            if let cell = self.cellForItem(at: indexPath) as? CollectionBaseCell {
                if indexPath.section < items.count && indexPath.row < items[indexPath.section].count {
                    let item = items[indexPath.section][indexPath.row]
                    cell.configurate(item, visible: true, prototype: false)
                }
            }
        }
    }
    
    private func processVMLayout(item: BaseCellViewModel, width: CGFloat) {
        if let autolayoutVM = item as? BaseAutolayoutCellViewModel {
            if autolayoutVM.canProcessInBackground {
                autolayoutVM.processInBackground(width)
            } else {
                DispatchQueue.main.sync {
                    item.processLayout(width, collectionView: self)
                }
            }
        } else {
            item.processLayout(width, collectionView: self)
        }
    }
    
    private func checkShowEmpty() {
        guard let emptyView = emptyProvider?.emptyView else { return }
        
        if showEmptyCondition() {
            addEmptyView()
        } else {
            emptyView.removeFromSuperview()
        }
    }
    
    private func getCollectionWidth() -> CGFloat {
        let inset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? UIEdgeInsets.zero
        return bounds.width - inset.left - inset.right
    }
    
    // MARK: items methods
    
    public func reloadCell(for itemId: String) {
        if let indexPath = indexPath(for: itemId) {
            reloadItems(at: [indexPath])
        }
    }
    
    public func reloadCells(for itemIds: [String]) {
        var indexPaths = [IndexPath]()
        itemIds.forEach({
            if let indexPath = indexPath(for: $0), !indexPaths.contains(indexPath) {
                indexPaths.append(indexPath)
            }
        })
        reloadItems(at: indexPaths)
    }
    
    public func cell(for itemId: String) -> CollectionBaseCell? {
        if let indexPath = indexPath(for: itemId) {
            layoutIfNeeded()
            return cellForItem(at: indexPath) as? CollectionBaseCell
        }
        return nil
    }
    
    public func getViewModelById<T>(_: T.Type, _ id: String) -> (IndexPath, T)? {
        for (section, sectionItems) in items.enumerated() {
            for (row, item) in sectionItems.enumerated() where item.id == id {
                return (IndexPath(item: row, section: section), item as! T)
            }
        }
        return nil
    }
    
    private func deleteCell(for itemId: String) {
        if let indexPath = indexPath(for: itemId) {
            items[indexPath.section].remove(at: indexPath.row)
            deleteItems(at: [indexPath])
        }
    }
    
    private func indexPath(for itemId: String?) -> IndexPath? {
        for (section, sectionItems) in items.enumerated() {
            for (row, item) in sectionItems.enumerated() where item.id == itemId {
                return IndexPath(item: row, section: section)
            }
        }
        return nil
    }

    // MARK: register cells
    
    func registerClass(_ cell: CollectionBaseCell.Type, identifier: String) {
        registeredClass[identifier] = cell
        register(cell, forCellWithReuseIdentifier: identifier)
    }
    
    func classForIdentifier(_ identifier: String) -> CollectionBaseCell.Type {
        if let registeredClass = registeredClass[identifier] {
            return registeredClass
        }
        fatalError("Cell Class doesn't registered, check 'cellType' property")
    }
    
    // MARK: - scroll logic
    
    private func needScrollToBottom(_ context: UpdateContext) -> Bool {
        switch context {
        case .pagination:
            return false
        default:
            return false
        }
    }
    
    private func rectAtIndexPath(_ indexPath: IndexPath?) -> CGRect? {
        if let indexPath = indexPath {
            return self.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
        }
        return nil
    }
    
    private func scrollToPreservePosition(oldRefRect: CGRect?, newRefRect: CGRect?, oldContentOffsetY: CGFloat) {
        guard let oldRefRect = oldRefRect, let newRefRect = newRefRect else {
            return
        }
        let diffY = newRefRect.minY - oldRefRect.minY
        contentOffset = CGPoint(x: 0, y: oldContentOffsetY + diffY)
    }
    
    public func scrollToBottom(animated: Bool) {
        let offsetY = bottomOffsetY()
        setContentOffset(CGPoint(x: 0, y: offsetY), animated: animated)
    }
    
    public func bottomOffsetY() -> CGFloat {
        return max(-contentInset.top, collectionViewLayout.collectionViewContentSize.height - bounds.height + contentInset.bottom)
    }
    
    public func isBottomCloser(offsetY: CGFloat = 0) -> Bool {
        let bottomY = bottomOffsetY()
        let diff = abs(contentOffset.y + offsetY - bottomY)
        return diff < 10
    }
    
    // MARK: - UICollectionViewDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section][indexPath.row]
        let cell = dequeueReusableCell(item.identifier, indexPath: indexPath)
        cell.configurate(item, visible: false, prototype: false)
        return cell
    }
    
    private func dequeueReusableCell(_ identifier: String, indexPath: IndexPath) -> CollectionBaseCell {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CollectionBaseCell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? CollectionBaseCell)?.willDisplay()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? CollectionBaseCell)?.didEndDisplay()
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.section][indexPath.row]
        return item.cellLayout.frame.size
    }
}

extension SbirkaView: CellHeightDelegate {
    public func cellHeightDidChange(_ vmId: String) {
        if let indexPath = indexPath(for: vmId) {
            let vm = items[indexPath.section][indexPath.row]
            if let cell = cellForItem(at: indexPath) as? CollectionBaseCell {
                collectionViewLayout.invalidateLayout()
                let newHeight = cell.contentView.systemLayoutSizeFitting(CGSize(width: cell.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
                var newFrame = cell.frame
                newFrame.size.height = newHeight
                performBatchUpdates({
                    vm.cellLayout.frame.size = newFrame.size
                    cell.frame = newFrame
                }, completion: nil)
            } else {
                let width = getCollectionWidth()
                updateQueue.async { [weak self] in
                    self?.processVMLayout(item: vm, width: width)
                    DispatchQueue.main.sync {
                        self?.collectionViewLayout.invalidateLayout()
                    }
                }
            }
        }
    }
}

extension SbirkaView {
    func indexPathsForVisibleItems<T>(type: T.Type) -> [IndexPath]? {
        return indexPathsForVisibleItems
            .sorted(by: { $0 < $1 })
            .filter({ cellForItem(at: $0) is T })
    }
}
