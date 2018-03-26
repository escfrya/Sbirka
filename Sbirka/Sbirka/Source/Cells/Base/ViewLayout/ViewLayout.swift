//
//  ViewLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

open class ViewLayout {
    var frame: CGRect
    var hidden: Bool
    
    public init(frame: CGRect, hidden: Bool = false) {
        self.frame = frame
        self.hidden = hidden
    }
    
    class var emptyLayout: ViewLayout {
        return ViewLayout(frame: CGRect.zero)
    }
}

extension ViewLayout {
    public var leftX: CGFloat {
        return frame.origin.x
    }
    public var topY: CGFloat {
        return frame.origin.y
    }
    public var rightX: CGFloat {
        return frame.origin.x + frame.width
    }
    public var bottomY: CGFloat {
        return frame.origin.y + frame.height
    }
    public var width: CGFloat {
        return frame.width
    }
    public var height: CGFloat {
        return frame.height
    }
    public var centerX: CGFloat {
        return frame.midX
    }
    public var centerY: CGFloat {
        return frame.midY
    }
}

extension UIView {
    public func applyLayout(_ layout: ViewLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
    }
}
