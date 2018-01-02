//
//  CellsRegistrotor.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation

public protocol CellsRegistrator {
    func registerCells(view: SbirkaView)
}

extension SbirkaView {
    func regCollectionCells(_ cells: [(CollectionBaseCell.Type, BaseCellViewModel.Type)]) {
        for cell in cells {
            self.registerClass(cell.0, identifier: Identifier.identifier(for: cell.1))
        }
    }
}
