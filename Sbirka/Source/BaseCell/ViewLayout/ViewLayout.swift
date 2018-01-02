//
//  ViewLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class ViewLayout {
    var frame: CGRect
    var hidden: Bool
    
    init(frame: CGRect, hidden: Bool = false) {
        self.frame = frame
        self.hidden = hidden
    }
    
    class var emptyLayout: ViewLayout {
        return ViewLayout(frame: CGRect.zero)
    }
}

extension ViewLayout {
    var leftX: CGFloat {
        return frame.origin.x
    }
    var topY: CGFloat {
        return frame.origin.y
    }
    var rightX: CGFloat {
        return frame.origin.x + frame.width
    }
    var bottomY: CGFloat {
        return frame.origin.y + frame.height
    }
    var width: CGFloat {
        return frame.width
    }
    var height: CGFloat {
        return frame.height
    }
    var centerX: CGFloat {
        return frame.midX
    }
    var centerY: CGFloat {
        return frame.midY
    }
}

extension UIView {
    func applyLayout(_ layout: ViewLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
    }
}
