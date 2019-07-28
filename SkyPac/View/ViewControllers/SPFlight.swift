//
//  SPFlight.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import UIKit

struct SPFlight: Decodable {
    var flightData: [FlightData]?
    
    enum CodingKeys: String, CodingKey {
        case flightData = "data"
    }
}

struct FlightData: Decodable, Hashable {
    
    static func == (lhs: FlightData, rhs: FlightData) -> Bool {
        return lhs.mapIdfrom == rhs.mapIdfrom && lhs.mapIdTo == rhs.mapIdTo
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mapIdfrom)
        hasher.combine(mapIdTo)
    }
    
    var id: String?
    var countryFrom: Country?
    var countryTo: Country?
    var departureTimeUTC: Int?
    var arrivalTimeUTC: Int?
    var mapIdfrom: String?
    var mapIdTo: String?
    var conversion: Conversion?
    var flyDuration: String?
    var route: [Route]?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case countryFrom = "countryFrom"
        case countryTo = "countryTo"
        case departureTimeUTC = "dTimeUTC"
        case arrivalTimeUTC = "aTimeUTC"
        case mapIdfrom = "mapIdfrom"
        case mapIdTo = "mapIdto"
        case conversion = "conversion"
        case flyDuration = "fly_duration"
        case route = "route"
    }
}

struct Route: Decodable {
    var flyNumber: Int?

    enum CodinkKeys: String, CodingKey {
        case flyNumber = "flight_no"
    }
}

struct Conversion: Decodable {
    var currency: Int?
    
    enum CodingKeys: String, CodingKey {
        case currency = "EUR"
    }
}

struct Country: Decodable {
    var code: String?
    var name: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case name = "name"
    }
}

