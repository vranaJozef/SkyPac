//
//  RequestBuilder.swift
//  SPFlight
//
//  Created by Jozef Vrana on 10/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    class func getFlights() -> Resource<Flight, APIError> {
        var resource = Resource<Flight, APIError>(jsonDecoder: JSONDecoder(), path: "")
        resource.method = .get
        let dateFrom = Date().ddmmYYYYFormatter()
        let dateTo = Date().addOneDay()
        let queryItems = ["v":"3",
                          "sort": "popularity",
                          "asc":"0",
                          "partner":"picky",
                          "select_airlines_exclude":"true",
                          "fly_from": "SK",
                          "fly_to": "",
                          "date_from": dateFrom,
                          "date_to": dateTo,
                          "limit":"50"]
        resource.queryItems = queryItems
        return resource
    }       
}
