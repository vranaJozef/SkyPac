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
    func updateSPFlight(_ SPFlight: SPFlight?)
}

class SPFlightManager {
    
    let client = Client.init(baseUrl: "https://api.skypicker.com/flights")
    var SPFlightTask: URLSessionTask?
    var SPFlight: SPFlight? {
        didSet {
            self.delegate?.updateSPFlight(self.SPFlight)
        }
    }
    var delegate: SPFlightManagerDelegate?
    
    func getAllSPFlight(completion: @escaping ((_ error: WebError<APIError>?) -> Void)) {
        self.SPFlightTask?.cancel()
        let resource = RequestBuilder.getPopularFlights()
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
