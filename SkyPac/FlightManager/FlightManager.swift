//
//  SPFlightManager.swift
//  SPFlight
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import UIKit

protocol FlightManagerDelegate {
    func updateFlight(_ flightDetail: [FlightData]?)
}

// Struct wrapper for ability to store NSCache

class StructWrapper: NSObject {
    
    let value: FlightData
    
    init(_ value: FlightData) {
        self.value = value
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? FlightData else {
            return false
        }
        return value.id == other.id
    }
}

class FlightManager {
    
    let client = Client.init(baseUrl: "https://api.skypicker.com/flights")
    var flightTask: URLSessionTask?
    let flightsCache = NSCache<NSString, AnyObject>()
    let dateFromCache = NSCache<NSString, NSString>()
    var shouldLoadFlights = Bool()
    var temporaryFlights = [FlightData]()
    var currentFlight: Flight? {
        didSet {
            if shouldLoadFlights {
                self.temporaryFlights.removeAll()
            }
            guard let excludedDuplicates = self.currentFlight?.flightData!.removeDuplicates(source: self.currentFlight!.flightData!) else { return }
            // iterate through parsed flights
            for (_, item) in excludedDuplicates.enumerated() {
                if let id = item.id {
                    if let cachedFlight = flightsCache.object(forKey: NSString(string: id))  {
                        // if there are chached flights, check if they are similar to parsed
                        if !cachedFlight.isEqual(item) && shouldLoadFlights {
                            self.temporaryFlights.append(item)
                        }
                    } else {
                        if shouldLoadFlights {
                            self.temporaryFlights.append(item)
                        }
                    }
                }
            }
            if self.temporaryFlights.count >= 5 {
                let slicedFlights = Array(self.temporaryFlights.dropLast(self.temporaryFlights.count - 5))
                for (_, item) in slicedFlights.enumerated() {
                    let wrappedStruct = StructWrapper.init(item)
                    // set the new flights
                    if let id = item.id {
                        flightsCache.setObject(wrappedStruct, forKey: id as NSString)
                    }
                }
                self.delegate?.updateFlight(slicedFlights)
            }
        }
    }
    var delegate: FlightManagerDelegate?
        
    func getAllFlights(completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.flightTask?.cancel()
        self.shouldLoadFlights = false
        let resource = RequestBuilder.getFlights()
        if let qi = resource.queryItems {
            if let cachedDate = dateFromCache.object(forKey: "dateFrom"), let newDate = qi["date_from"] {
                if String(cachedDate) != newDate {
                    if let dateFrom = qi["date_from"] {
                        dateFromCache.setObject(dateFrom! as NSString, forKey: "dateFrom")
                        self.shouldLoadFlights = true
                    }
                }
            } else {
                if let dateFrom = qi["date_from"] {
                    dateFromCache.setObject(dateFrom! as NSString, forKey: "dateFrom")
                    self.shouldLoadFlights = true
                }
            }
        }
        self.flightTask = client.load(resource: resource) {[weak self] response in
            if let flight = response.value {
                completion(nil)
                self?.currentFlight = flight
                } else if let error = response.error {
                completion(error)
            }
        }
    }
}
