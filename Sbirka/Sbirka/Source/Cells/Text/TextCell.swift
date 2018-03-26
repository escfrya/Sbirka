//
//  TextCell.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public class TextCell: BaseCollectionCell<TextCellViewModel, AutolayoutCellLayout> {
    var labelView: UILabel!
    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var leftConstraint: NSLayoutConstraint!
    private var rightConstraint: NSLayoutConstraint!
    
    override public func setupViews() {
        super.setupViews()
        
        backgroundColor = UIColor.clear
        labelView = UILabel()
        labelView.numberOfLines = 0
        contentView.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
        bottomConstraint = labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        leftConstraint = labelView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0)
        rightConstraint = labelView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0)
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leftConstraint,
            rightConstraint
        ])
    }
    
    override public func configurate(_ item: TextCellViewModel, visible: Bool, prototype: Bool) {
        super.configurate(item, visible: visible, prototype: prototype)
        
        labelView.textAlignment = item.aligment
        labelView.attributedText = item.text
        topConstraint.constant = item.top
        bottomConstraint.constant = -item.bottom
        leftConstraint.constant = item.left
        rightConstraint.constant = -item.right
    }
}
