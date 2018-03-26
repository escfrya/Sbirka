//
//  AttributedTextLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class AttributedTextLayout: ViewLayout {    
    var text: NSAttributedString!
    var aligment: NSTextAlignment!
    
    public init(frame: CGRect, text: NSAttributedString, aligment: NSTextAlignment = .left, hidden: Bool = false) {
        self.text = text
        self.aligment = aligment
        
        super.init(frame: frame, hidden: hidden)
    }
    
    public init(text: NSAttributedString, width: CGFloat, origin: CGPoint, aligment: NSTextAlignment = .left) {
        self.text = text
        self.aligment = aligment
        
        let textHeight = text.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        super.init(frame: CGRect(x: origin.x, y: origin.y, width: width, height: textHeight))
    }
    
    override class var emptyLayout: AttributedTextLayout {
        return AttributedTextLayout(frame: CGRect.zero, text: NSAttributedString(string: ""), hidden: true)
    }
}

extension UILabel {
    public func applyLayout(_ layout: AttributedTextLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        attributedText = layout.text
        textAlignment = layout.aligment
    }
}

extension UITextView {
    public func applyLayout(_ layout: AttributedTextLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        attributedText = layout.text
        textAlignment = layout.aligment
    }
}

extension UIButton {
    public func applyLayout(_ layout: AttributedTextLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        setAttributedTitle(layout.text, for: .normal)
        let invText = layout.text.mutableCopy() as! NSMutableAttributedString
        invText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: invText.length))
        setAttributedTitle(invText, for: .highlighted)
    }
}

