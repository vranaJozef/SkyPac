//
//  ViewController.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flightTipsTableView: UITableView!
    let cellID = "flightCell"
    var popularFlights: [SPFlight]?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flightTipsTableView.register(UINib(nibName: "SPFlightTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        let baseURL = URL(string: "https://api.skypicker.com/flights")!
        let dateFrom = Date().ddmmYYYYFormatter()
        let dateTo = Date().addOneDay()        
        let queryItems = ["fly_from": "UK",
                          "fly_to": "JFK",
                          "date_from": dateFrom,
                          "date_to": dateTo,
                          "sort": "popularity"]
        let finalURL = baseURL.addURLParameters(items: queryItems)
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let data = data {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            data, options: [])
                        guard let jsonArray = jsonResponse as? [String: Any] else {
                            return
                        }
                        let picked = jsonArray["data"] as! [Any?]
                        print(picked[0])
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightTipsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SPFlightTableViewCell
        cell.flightTimeLabel.text = "\(indexPath.row)"
        return cell
    }
    
    
}
