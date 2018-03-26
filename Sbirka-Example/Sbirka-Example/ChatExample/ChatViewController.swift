//
//  ChatViewController.swift
//  Sbirka-Example
//
//  Created by Игорь on 26/03/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit
import Sbirka

class ChatViewController: UIViewController {
    lazy var sbirkaView: SbirkaView = { [unowned self] in
        let view = SbirkaView()
        view.cellType = CellsRegistrotorValue.chat
        view.translatesAutoresizingMaskIntoConstraints = false
        view.updateItemsCompleted = { [weak view] in view?.scrollToBottom(animated: true) }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(sbirkaView)
        
        NSLayoutConstraint.activate([
            sbirkaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sbirkaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sbirkaView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            sbirkaView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
        
        update(context: .syncLoad)
    }

    private let texts = ["Swift. A powerful open language that lets everyone build amazing apps.",
                         "Swift is a robust and intuitive programming language created by Apple for building apps for iOS, Mac, Apple TV, and Apple Watch. It’s designed to give developers more freedom than ever. Swift is easy to use and open source, so anyone with an idea can create something incredible.",
                         "Developers are already doing great things with Swift.",
                         "Swift is a fast and efficient language that provides real-time feedback and can be seamlessly incorporated into existing Objective-C code. So developers are able to write safer, more reliable code, save time, and create even richer app experiences."]
    
    private func update(context: UpdateContext) {
        var newItems: [BaseCellViewModel] = []
        for i in 1...100 {
            newItems.append(MessageCellViewModel(message: Message(id: "message_\(i)", text: randomText(), avatarUrl: "avatar")))
        }
        sbirkaView.update(items: [newItems], context: context)
    }
    
    private func randomText() -> String {
        let index = Int(arc4random_uniform(4))
        return texts[index]
    }
}
