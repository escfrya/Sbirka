//
//  Identifier.swift
//  Sbirka
//
//  Created by Игорь on 03/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation

public class Identifier {
    class func identifier(for vmType: AnyClass) -> String {
        return String(describing: type(of: vmType)).components(separatedBy: ".")[0]
    }
}
