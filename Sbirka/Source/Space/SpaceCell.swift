//
//  SpaceCell.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

class SpaceCell: BaseCollectionCell<SpaceCellViewModel, AutolayoutCellLayout> {
    
    private var height: NSLayoutConstraint!
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.clear
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        height = contentView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([height])
    }
    
    override func configurate(_ item: SpaceCellViewModel, visible: Bool, prototype: Bool) {
        super.configurate(item, visible: visible, prototype: prototype)
        
        height.constant = item.height
    }
}
