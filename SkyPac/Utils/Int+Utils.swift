//
//  Int+Utils.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 28/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

extension Int {
    
    func convertToDDMMYYYY() -> String {
        let timeInterval = Double(self)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date.HHMMSS()
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
