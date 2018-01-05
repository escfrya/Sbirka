//
//  TextCellViewModel.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class TextCellViewModel: BaseAutolayoutCellViewModel {
    var text: NSAttributedString!
    var aligment: NSTextAlignment!
    var top: CGFloat = 0
    var bottom: CGFloat = 0
    var left: CGFloat = 0
    var right: CGFloat = 0
    var height: CGFloat?
    
    public init(text: NSAttributedString, id: String = UUID().uuidString, aligment: NSTextAlignment = .left, background: UIColor = UIColor.clear, top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 16, right: CGFloat = 16, height: CGFloat? = nil) {
        super.init(id: id)
        
        self.text = text
        self.aligment = aligment
        self.background = background
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.height = height
    }
    
    override var cellHeight: CGFloat? {
        return height
    }
}
