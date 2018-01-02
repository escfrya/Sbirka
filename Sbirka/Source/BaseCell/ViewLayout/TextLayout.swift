//
//  TextLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class TextLayout: ViewLayout {
    
    var text: String!
    var font: UIFont?
    
    init(frame: CGRect, text: String, font: UIFont?, hidden: Bool = false) {
        self.text = text
        self.font = font
        
        super.init(frame: frame, hidden: hidden)
    }
    
    init(text: String, font: UIFont, width: CGFloat, origin: CGPoint) {
        self.text = text
        self.font = font
        
        let textHeight = (text as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedStringKey.font: font], context: nil).height
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: textHeight))
    }
    
    override class var emptyLayout: TextLayout {
        return TextLayout(frame: CGRect.zero, text: "", font: UIFont.systemFont(ofSize: 10), hidden: true)
    }
}

extension UILabel {
    func applyLayout(_ layout: TextLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        text = layout.text
        if let layoutFont = layout.font {
            font = layoutFont
        }
    }
}

extension UITextView {
    func applyLayout(_ layout: TextLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        text = layout.text
        if let layoutFont = layout.font {
            font = layoutFont
        }
    }
}
