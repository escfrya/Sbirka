//
//  BaseCollectionCell.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public protocol CellHeightDelegate: class {
    func cellHeightDidChange(_ vmId: String)
}

public class CollectionBaseCell: UICollectionViewCell {
    
    public weak var heightDelegate: CellHeightDelegate?
    
    public func configurate(_ item: BaseCellViewModel, visible: Bool, prototype: Bool) {
    }
    
    public func willDisplay() {
    }
    
    public func didEndDisplay() {
    }
}

public class BaseCollectionCell<TViewModel: BaseCellViewModel, TLayout: BaseCellLayout>: CollectionBaseCell {
    
    public weak var item: TViewModel?

    public var selectable: Bool {
        return false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    override public func layoutSubviews() {
        contentView.frame = bounds
        super.layoutSubviews()
    }
    
    private func setup() {
        
        if selectable {
            let selectedView = UIView(frame: bounds)
            selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            selectedBackgroundView = selectedView
        }
        
        setupViews()
    }
    
    func setupViews() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: contentView.superview!.bottomAnchor, constant: 0)
        bottomConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentView.superview!.topAnchor, constant: 0),
            contentView.leftAnchor.constraint(equalTo: contentView.superview!.leftAnchor, constant: 0),
            contentView.rightAnchor.constraint(equalTo: contentView.superview!.rightAnchor, constant: 0),
            bottomConstraint
        ])
    }
    
    func raiseHeightChanged() {
        if let itemId = item?.id {
            heightDelegate?.cellHeightDidChange(itemId)
        }
    }
    
    // method for autolayout cells (with prototypes)
    public func configurate(_ item: TViewModel, visible: Bool, prototype: Bool) {
        configurate(item, visible: visible)
    }
    
    // method for frame layout cells
    public func configurate(_ item: TViewModel, visible: Bool) {
        self.item = item
        contentView.backgroundColor = item.background ?? UIColor.clear
        if let cellLayout = item.cellLayout as? TLayout {
            applyLayout(cellLayout, visible: visible)
        }
    }
    
    override public func configurate(_ item: BaseCellViewModel, visible: Bool, prototype: Bool) {
        if let item = item as? TViewModel {
            self.configurate(item, visible: visible, prototype: prototype)
        }
    }
    
    internal func applyLayout(_ layout: TLayout, visible: Bool) {
        
    }
}
