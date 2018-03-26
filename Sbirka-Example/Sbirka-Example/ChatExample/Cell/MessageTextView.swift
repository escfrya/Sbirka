//
//  MessageTextView.swift
//  Sbirka-Example
//
//  Created by Игорь on 26/03/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

final class MessageTextView: UITextView {
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        if type(of: gestureRecognizer) == UILongPressGestureRecognizer.self && gestureRecognizer.delaysTouchesEnded {
            super.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
