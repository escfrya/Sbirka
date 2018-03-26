//
//  MessageCell.swift
//  TemplateProject
//
//  Created by Игорь on 09/05/2017.
//  Copyright © 2017 xuli. All rights reserved.
//

import Foundation
import Sbirka

class MessageCell: BaseCollectionCell<MessageCellViewModel, MessageCellLayout>, UITextViewDelegate {

    private lazy var textContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.cyan
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var body: MessageTextView = {
        let view = MessageTextView()
        view.isEditable = false
        view.layoutManager.allowsNonContiguousLayout = true
        view.isScrollEnabled = false
        view.dataDetectorTypes = UIDataDetectorTypes()
        view.backgroundColor = UIColor.clear
        view.textContainerInset = UIEdgeInsets.zero
        view.textContainer.lineFragmentPadding = 0
        return view
    }()
    
    private lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 7
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        
        contentView.addSubview(avatar)
        contentView.addSubview(textContainer)
        textContainer.addSubview(body)
    }
    
    override func configurate(_ item: MessageCellViewModel, visible: Bool) {
        super.configurate(item, visible: visible)
        
    }
    
    override public func applyLayout(_ layout: MessageCellLayout, visible: Bool) {
        super.applyLayout(layout, visible: visible)
        
        avatar.applyLayout(layout.avatarLayout)
        textContainer.applyLayout(layout.textContainerLayout)
        body.applyLayout(layout.bodyLayout)
    }
    
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return false
    }
}
