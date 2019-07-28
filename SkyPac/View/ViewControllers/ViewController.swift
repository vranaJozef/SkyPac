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
    var flight: SPFlight?
    
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
    
    // MARK: - FlightManagerDelegate
    
    func updateSPFlight(_ flight: SPFlight?) {
        if let flight = flight {
            self.flight = flight
            DispatchQueue.main.async {
                self.flightTipsTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flight?.flightData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightTipsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SPFlightTableViewCell
        cell.flightDepartureLabel.text = self.flight?.flightData![indexPath.row].countryFrom?.name
        cell.flightDestinationLabel.text = self.flight?.flightData![indexPath.row].countryTo?.name        
        let key = self.flight?.flightData![indexPath.row].mapIdTo!
        cell.flightImageView.imageFromServerURL("https://images.kiwi.com/photos/610x251/\(key!).jpg", placeHolder: nil)
        
        return cell
    }
}

