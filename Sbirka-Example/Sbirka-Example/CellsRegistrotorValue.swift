//
//  CellsRegistrotorValue.swift
//  Sbirka-Example
//
//  Created by Игорь on 26/03/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import Sbirka

public enum CellsRegistrotorValue: CellsRegistrator {
    case test
    case chat
    
    public func registerCells(view: SbirkaView) {
        switch self {
        case .test:
            view.regCollectionCells([
                (TextCell.self, TextCellViewModel.self),
                (SpaceCell.self, SpaceCellViewModel.self)
            ])
        case .chat:
            view.regCollectionCells([
                (MessageCell.self, MessageCellViewModel.self)
            ])
        }
    }
}
