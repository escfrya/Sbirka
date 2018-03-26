//
//  MessageCellLayout.swift
//  TemplateProject
//
//  Created by Игорь on 09/05/2017.
//  Copyright © 2017 xuli. All rights reserved.
//

import Foundation
import Sbirka

class MessageCellLayout: BaseCellLayout {
    var avatarLayout: ImageLayout
    var textContainerLayout: ViewLayout
    var bodyLayout: AttributedTextLayout

    init(width: CGFloat, avatarLayout: ImageLayout, textContainerLayout: ViewLayout, bodyLayout: AttributedTextLayout, frame: CGRect) {
        
        self.avatarLayout = avatarLayout
        self.textContainerLayout = textContainerLayout
        self.bodyLayout = bodyLayout
        
        super.init(width: width, frame: frame)
    }
}
