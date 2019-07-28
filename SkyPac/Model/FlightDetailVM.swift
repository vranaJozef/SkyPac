//
//  FlightDetailVM.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 28/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import UIKit

class FlightDetailVM: NSObject {
    
    var item: FlightData?          
    var currency: String?
    var price: String?
    
    init(_ item: FlightData) {
        self.item = item        
    }
    
    func update() {
        if let item = self.item {
            let locale = NSLocale(localeIdentifier: "EUR")
            let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: "EUR")
            if let currency = item.conversion?.currency {
                self.currency = currencySymbol
                self.price = String("\(currency)\(currencySymbol!)")
            }
        }
    }
}
