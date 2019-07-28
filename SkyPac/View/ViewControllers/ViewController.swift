//
//  ViewController.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SPFlightManagerDelegate {

    @IBOutlet weak var flightTipsTableView: UITableView!
    let cellID = "flightCell"
    let networkManager = SPFlightManager()
    var flight: [FlightData]?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flightTipsTableView.register(UINib(nibName: "SPFlightTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        networkManager.delegate = self
        if Reachability.isConnectedToNetwork() {
            self.networkManager.getAllSPFlight { (error) in
                if error == nil {                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flightDetail" {
            let flightDetailVC = segue.destination as! FlightDetailVC
            if let flight = self.flight {
                let indexPath = sender as! IndexPath
                flightDetailVC.flightInfo = flight[indexPath.row]
            }
        }
    }
    // MARK: - FlightManagerDelegate
    
    func updateSPFlight(_ flight: [FlightData]?) {
        if let flight = flight {
            self.flight = flight            
            DispatchQueue.main.async {
                self.flightTipsTableView.reloadData()
            }
        }
    }
    
    @IBAction func onRefresh(_ sender: UIBarButtonItem) {
        self.networkManager.getAllSPFlight { (error) in
            if error == nil {
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flight?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightTipsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SPFlightTableViewCell
        cell.flightDepartureLabel.text = self.flight?[indexPath.row].countryFrom?.name
        cell.flightArrivalLabel.text = self.flight?[indexPath.row].countryTo?.name
        cell.flightDepartureTime.text = self.flight![indexPath.row].departureTimeUTC?.convertToDDMMYYYY()
        cell.flightArrivalTime.text = self.flight![indexPath.row].arrivalTimeUTC?.convertToDDMMYYYY()
        cell.departureDate.text = Date().ddmmYYYYFormatter()
        let locale = NSLocale(localeIdentifier: "EUR")
        let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: "EUR")
        cell.price.text = String("\(self.flight![indexPath.row].conversion!.currency!)\(currencySymbol!)")
        let key = self.flight?[indexPath.row].mapIdTo!
        cell.flightImageView.imageFromServerURL("https://images.kiwi.com/photos/610x251/\(key!).jpg", placeHolder: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flightTipsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "flightDetail", sender: indexPath)
    }
}

