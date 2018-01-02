//
//  SbirkaEmptyViewDelegate.swift
//  Sbirka
//
//  Created by Игорь on 03/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public protocol SbirkaEmptyViewProvider: class {
    var emptyView: UIView? { get }
}

public protocol SbirkaEmptyViewDelegate {
    func showEmptyCondition() -> Bool
    func addEmptyView()
}

extension SbirkaEmptyViewDelegate where Self: SbirkaView {
    public func showEmptyCondition() -> Bool {
        return items.count == 0
        //        return items.filter({ $0.filter({ !($0 is SpaceCellViewModel) }).count > 0 }).count == 0
    }
    
    public func addEmptyView() {
        guard let emptyView = self.emptyProvider?.emptyView else { return }
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            emptyView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 20)
        ])
    }
}

extension SbirkaView: SbirkaEmptyViewDelegate {}
