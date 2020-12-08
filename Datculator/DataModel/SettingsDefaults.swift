//
//  SettingsDefaults.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 11.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import Foundation

@propertyWrapper
struct SettingsDefaults <T> {
    let key: String
    let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
