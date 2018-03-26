//
//  MainViewController.swift
//  Sbirka-Example
//
//  Created by Игорь on 26/03/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import Sbirka

class MainViewController: UIViewController {
    lazy var sbirkaView: SbirkaView = { [unowned self] in
        let view = SbirkaView()
        view.cellType = CellsRegistrotorValue.test
        view.translatesAutoresizingMaskIntoConstraints = false
        view.touched = { [weak self] in self?.touched(item: $0) }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sbirkaView)
        
        NSLayoutConstraint.activate([
            sbirkaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sbirkaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sbirkaView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            sbirkaView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
        ])
        
//        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        update()
    }

    private func update() {
        let newItems: [BaseCellViewModel] = [
            SpaceCellViewModel(id: "space_1", height: 20),
            TextCellViewModel(text: NSAttributedString(string: "Dinamic changes"), id: "cell_1"),
            TextCellViewModel(text: NSAttributedString(string: "Chat"), id: "cell_2")
        ]
        sbirkaView.update(items: [newItems], context: .firstLoad)
    }
    
    private func touched(item: BaseCellViewModel) {
        switch item.id {
        case "cell_1":
            navigationController?.pushViewController(ViewController(), animated: true)
        case "cell_2":
            navigationController?.pushViewController(ChatViewController(), animated: true)
        default:
            break
        }
    }
}
