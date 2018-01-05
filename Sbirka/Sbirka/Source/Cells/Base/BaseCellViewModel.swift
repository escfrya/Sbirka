//
//  BaseCellViewModel.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class BaseCellViewModel {
    
    var background: UIColor?
    var cellLayout: BaseCellLayout!
    
    var id: String = ""
    //    var oldId: String?
    
    var idInt: Int64 {
        return Int64(id) ?? 0
    }
    
    init(id: String) {
        self.id = id
    }
    
    //    var identifier: String {
    //        return BaseCellViewModel.ident(self.dynamicType)
    //    }
    //
    //    class func ident(type: BaseCellViewModel.Type) -> String {
    //        return String(type)
    //    }
    
    var identifier: String {
        return Identifier.identifier(for: type(of: self))
    }
    
    internal func processLayout(_ width: CGFloat, collectionView: SbirkaView) {
        processLayout(width)
    }
    
    func processLayout(_ width: CGFloat) {
        
    }
    
    func reprocessLayout() {
        processLayout(cellLayout.cellWidth)
    }
}
