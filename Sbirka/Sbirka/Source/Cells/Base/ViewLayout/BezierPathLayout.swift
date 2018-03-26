//
//  BezierPathLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class BezierPathLayout: ViewLayout {
    var path: UIBezierPath?
    var strokeColor: UIColor
    var fillColor: UIColor
    var lineDashPattern: [NSNumber]?
    var borderWidth: CGFloat = 0
    
    public init(frame: CGRect, path: UIBezierPath?, strokeColor: UIColor, fillColor: UIColor, borderWidth: CGFloat, lineDashPattern: [NSNumber]?, hidden: Bool = false) {
        self.path = path
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.borderWidth = borderWidth
        self.lineDashPattern = lineDashPattern
        
        super.init(frame: frame, hidden: hidden)
    }
}
