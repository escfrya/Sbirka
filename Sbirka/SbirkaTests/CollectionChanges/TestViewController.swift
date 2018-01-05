//
//  TestViewController.swift
//  SbirkaTests
//
//  Created by Игорь on 03/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit
@testable import Sbirka

class TestViewController: UIViewController {
    lazy var sbirkaView: SbirkaView = {
        let view = SbirkaView()
        view.cellType = CellsRegistrotorValue.test()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sbirkaView)
        
        NSLayoutConstraint.activate([
            sbirkaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            sbirkaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            sbirkaView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            sbirkaView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            ])
    }
}
