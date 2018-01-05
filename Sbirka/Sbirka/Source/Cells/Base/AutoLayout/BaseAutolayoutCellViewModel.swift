//
//  BaseAutolayoutCellViewModel.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class BaseAutolayoutCellViewModel: BaseCellViewModel {
    static var autoLayoutCellsPrototypes: [String: CollectionBaseCell] = [:]
    
    internal func process(width: CGFloat) -> CGFloat {
        return width
    }
    
    override func processLayout(_ width: CGFloat, collectionView: SbirkaView) {
        let width = process(width: width)
        let identifier = Identifier.identifier(for: type(of: self))
        var prototype: CollectionBaseCell!
        prototype = BaseAutolayoutCellViewModel.autoLayoutCellsPrototypes[identifier]
        if prototype == nil {
            let cellType = collectionView.classForIdentifier(identifier)
            prototype = cellType.init()
            BaseAutolayoutCellViewModel.autoLayoutCellsPrototypes[identifier] = prototype
            prototype.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: 0))
        }
        prototype.setNeedsLayout()
        prototype.layoutIfNeeded()
        prototype.configurate(self, visible: false, prototype: true)
        prototype.setNeedsLayout()
        prototype.layoutIfNeeded()
        let height = prototype.contentView.systemLayoutSizeFitting(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        self.cellLayout = AutolayoutCellLayout(width: width, cellSize: CGSize(width: width, height: height))
    }
    
    var canProcessInBackground: Bool {
        return cellHeight != nil
    }
    
    func processInBackground(_ width: CGFloat) {
        if let height = cellHeight {
            let width = process(width: width)
            self.cellLayout = AutolayoutCellLayout(width: width, cellSize: CGSize(width: width, height: height))
        }
    }
    
    var cellHeight: CGFloat? {
        return nil
    }
}
