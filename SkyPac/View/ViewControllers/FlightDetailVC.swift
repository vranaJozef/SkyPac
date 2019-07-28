//
//  FlightDetailVC.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 28/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class FlightDetailVC: UIViewController {
    
    var flightInfo: FlightData?
    @IBOutlet weak var arrivalImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var flightInfoTableView: UITableView!
    let cellID = "flightDetailCell"
    var tableInfo = [String]()
    var tableKeys = [String]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flight = flightInfo {
            let locale = NSLocale(localeIdentifier: "EUR")
            let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: "EUR")
            if let currency = flight.conversion?.currency {
                self.price.text = String("\(currency)\(currencySymbol!)")
            }
            let key = flight.mapIdTo
            self.arrivalImage.imageFromServerURL("https://images.kiwi.com/photos/610x251/\(key!).jpg", placeHolder: nil)
            self.tableKeys = ["Departure city",
                         "Arrival city",
                         "Fly number",
                         "Fly duration",
                         "Departure time",
                         "Arrival time"]
           
            self.tableInfo.append(flight.countryFrom?.name ?? "")
            self.tableInfo.append(flight.countryTo?.name ?? "")
            self.tableInfo.append("\(String(describing: flight.route![0].flyNumber))" )
            self.tableInfo.append(flight.flyDuration ?? "")
            self.tableInfo.append(flight.departureTimeUTC?.convertToDDMMYYYY() ?? "")
            self.tableInfo.append(flight.arrivalTimeUTC?.convertToDDMMYYYY() ?? "")
            
//            self.tableInfo = [flight.countryFrom?.name ?? "",
//                              flight.countryTo?.name ?? "",
//                              flight.flyNumber ?? "",
//                              flight.flyDuration ?? "",
//                              flight.departureTimeUTC?.convertToDDMMYYYY() ?? "",
//                              flight.arrivalTimeUTC?.convertToDDMMYYYY() ?? ""]
        }
    }
}

extension FlightDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightInfoTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = tableKeys[indexPath.row]
        cell.detailTextLabel?.text = tableInfo[indexPath.row]
        return cell
    }
}
