//
//  MessageCellViewModel.swift
//  TemplateProject
//
//  Created by Игорь on 09/05/2017.
//  Copyright © 2017 xuli. All rights reserved.
//

import Foundation
import Sbirka

class Message {
    var id: String = ""
    var text: String?
    var avatarUrl: String?
    
    init(id: String, text: String?, avatarUrl: String?) {
        self.id = id
        self.text = text
        self.avatarUrl = avatarUrl
    }
}

class MessageCellViewModel: BaseCellViewModel {
    var message: Message
    var attributedText: NSAttributedString
    
    init(message: Message) {
        self.message = message
        attributedText = NSAttributedString(string: message.text ?? "", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)])
        
        super.init(id: message.id)
    }

    override public func processLayout(_ width: CGFloat) {
        super.processLayout(width)

        let avatarLayout = ImageLayout(frame: CGRect(x: 10, y: 10, width: 30, height: 30), source: .named(message.avatarUrl ?? ""))
        let bodyLayout = AttributedTextLayout(text: attributedText, width: width - 60, origin: CGPoint(x: 10, y: 10))
        let textContainerLayout = ViewLayout(frame: CGRect(x: 50, y: 5, width: width - 60, height: bodyLayout.height + 20))
        self.cellLayout = MessageCellLayout(width: width, avatarLayout: avatarLayout, textContainerLayout: textContainerLayout, bodyLayout: bodyLayout, frame: CGRect(x: 0, y: 0, width: width, height: textContainerLayout.bottomY + 5))
    }
}
