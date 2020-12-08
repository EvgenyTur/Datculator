//
//  Double+Extension.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 11.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import Foundation

extension Int {
    func absolute() -> Int {
        return self > 0 ? self : -1 * self
    }
}
