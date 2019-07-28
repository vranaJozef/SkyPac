//
//  SPFlightManager.swift
//  SPFlight
//
//  Created by Jozef Vrana on 11/03/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import UIKit

protocol SPFlightManagerDelegate {
    func updateSPFlight(_ SPFlight: [FlightData]?)
}

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

class SPFlightManager {
    
    let client = Client.init(baseUrl: "https://api.skypicker.com/flights")
    var SPFlightTask: URLSessionTask?
    let imageCache = NSCache<NSString, AnyObject>()
    let dateFromCache = NSCache<NSString, NSString>()
    var shouldLoadFlights = Bool()
    var slicedFlights = [FlightData]()
    var SPFlight: SPFlight? {
        didSet {
            if shouldLoadFlights {
                self.slicedFlights.removeAll()
            }
            guard let excludedDuplicates = self.SPFlight?.flightData!.uniq(source: self.SPFlight!.flightData!) else { return }
            // iterate through parsed flights
            for (_, item) in excludedDuplicates.enumerated() {
                if let cachedFlight = imageCache.object(forKey: NSString(string: item.id!))  {
                    // if there are chached flights, check if they are similar to parsed
                    if !cachedFlight.isEqual(item) && shouldLoadFlights {
                        self.slicedFlights.append(item)
                    }
                } else {
                    if shouldLoadFlights {
                        self.slicedFlights.append(item)
                    }
                }
            }
            let sliced = Array(self.slicedFlights.dropLast(self.slicedFlights.count - 5))
            for (_, item) in sliced.enumerated() {
                let wrappedStruct = StructWrapper.init(item)
                // set the new flights
                imageCache.setObject(wrappedStruct, forKey: item.id! as NSString)
            }
            self.delegate?.updateSPFlight(sliced)
        }
    }
    var delegate: SPFlightManagerDelegate?
        
    func getAllSPFlight(completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.SPFlightTask?.cancel()
        self.shouldLoadFlights = false
        let resource = RequestBuilder.getPopularFlights()
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
        self.SPFlightTask = client.load(resource: resource) {[weak self] response in
            if let SPFlight = response.value {
                completion(nil)
                self?.SPFlight = SPFlight
                } else if let error = response.error {
                completion(error)
            }
        }
    }
}
