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
    func updateImage(_ image: UIImage?)
}

class SPFlightManager {
    
    let client = Client.init(baseUrl: "https://api.skypicker.com/flights")
    var SPFlightTask: URLSessionTask?
    var SPFlight: SPFlight? {
        didSet {
            self.delegate?.updateSPFlight(self.SPFlight)
        }
    }
    var destinationImage: UIImage? {
        didSet {
            self.delegate?.updateImage(self.destinationImage)
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
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        let photoURL = URL(string: "https://images.kiwi.com/photos/610x251/\(url).jpg")!
        getData(from: photoURL) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            self.destinationImage = UIImage(data: data)
        }
    }
}
