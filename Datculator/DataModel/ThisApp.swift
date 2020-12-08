//
//  ThisApp.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 11.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import Foundation
import SwiftUI

struct ThisApp {
    static func appVersion() -> String {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let build = Bundle.main.infoDictionary!["CFBundleVersion"]!
        return "\(version) (\(build))"
    }
    
    static func copyRightLabel() -> String {
        var copyright = ""
        let components = Calendar.current.dateComponents([.year], from: Date())
        
        if let currentYear = components.year {
            copyright = "© 2012 - \(currentYear) Avencode"
        }
        return copyright
    }
}
