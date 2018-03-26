//
//  BaseCellViewModel.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

open class BaseCellViewModel {
    open var background: UIColor?
    open var cellLayout: BaseCellLayout!
    open var id: String = ""

    public init(id: String) {
        self.id = id
    }

    open var identifier: String {
        return Identifier.identifier(for: type(of: self))
    }
    
    open func processLayout(_ width: CGFloat, collectionView: SbirkaView) {
        processLayout(width)
    }
    
    open func processLayout(_ width: CGFloat) {
        
    }
    
    func reprocessLayout() {
        processLayout(cellLayout.cellWidth)
    }
}
