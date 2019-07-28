//
//  Int+Utils.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 28/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

extension Int {
    
    func ddMMYYYYFormatter() -> String {
        let timeInterval = Double(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date.hhMMSSFormatter()
    }
    
    func toDate() -> Date {
        let timeInterval = Double(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
}

extension Double {
    
    func toString() -> String {
        return String(self)
    }
}
