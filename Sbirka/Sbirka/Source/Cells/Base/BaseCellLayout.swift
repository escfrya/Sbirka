//
//  BaseCellLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

open class BaseCellLayout: ViewLayout {
    var cellWidth: CGFloat = 0
    
    public init(width: CGFloat, frame: CGRect, hidden: Bool = false) {
        super.init(frame: frame, hidden: hidden)
        
        self.cellWidth = width
    }
    
    public init(width: CGFloat, cellSize: CGSize, hidden: Bool = false) {
        super.init(frame: CGRect(origin: CGPoint.zero, size: cellSize), hidden: hidden)
        
        self.cellWidth = width
    }
}
