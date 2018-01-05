//
//  BaseCellView.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

class BaseCellView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    internal func setupViews() {
        
    }
}
