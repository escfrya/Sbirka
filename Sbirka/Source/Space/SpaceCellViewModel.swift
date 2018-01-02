//
//  SpaceCellViewModel.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

class SpaceCellViewModel: BaseAutolayoutCellViewModel {
    var height: CGFloat = 0
    
    init(id: String = UUID().uuidString, height: CGFloat) {
        super.init(id: id)
        
        self.height = height
    }
    
    override var cellHeight: CGFloat? {
        return height
    }
}
