//
//  SPFlight.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

struct SPFlight: Decodable {
    var data: SPFlightDetails?
}

struct SPFlightDetails: Decodable {
    
    var id: String?
    var countryFrom: String?
    var countryTo: String?
    var price: String?
}

