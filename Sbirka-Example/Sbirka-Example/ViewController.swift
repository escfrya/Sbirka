//
//  ViewController.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import UIKit
import Sbirka

class ViewController: UIViewController {
    lazy var sbirkaView: SbirkaView = { [unowned self] in
        let view = SbirkaView()
        view.emptyProvider = self
        view.cellType = CellsRegistrotorValue.test
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var button: UIButton = { [unowned self] in
        let view = UIButton()
        view.setTitle("animate", for: .normal)
        view.setTitleColor(UIColor.black, for: .normal)
        view.addTarget(self, action: #selector(ViewController.buttonTouched), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var space2Value: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(sbirkaView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            sbirkaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sbirkaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sbirkaView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            sbirkaView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        update(context: .firstLoad)
        sbirkaView.update(items: [], context: .firstLoad)
    }
    
    private func update(context: UpdateContext) {
        var newItems: [BaseCellViewModel] = []
        newItems.append(SpaceCellViewModel(id: "space_1", height: 20))
        newItems.append(TextCellViewModel(text: NSAttributedString(string: "Hello"), id: "text_1"))
        newItems.append(SpaceCellViewModel(id: "space_2", height: space2Value))
        newItems.append(TextCellViewModel(text: NSAttributedString(string: "World!!!"), id: "text_2"))
        sbirkaView.update(items: [newItems], context: context)
    }
    
    @objc private func buttonTouched() {
        space2Value += 10
        update(context: .normal) // animate changes
    }
    
    lazy var empty: UIView = {
        let view = UILabel()
        view.text = "Empty :-("
        return view
    }()
}

extension ViewController: SbirkaEmptyViewProvider {
    var emptyView: UIView? {
        return empty
    }
}
