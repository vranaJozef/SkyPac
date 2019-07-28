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
    var popularFlights: [SPFlight]?
    let networkManager = SPFlightManager()
    var flight: SPFlight?
    var destinationImage: UIImage?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flightTipsTableView.register(UINib(nibName: "SPFlightTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        networkManager.delegate = self
    }
    
    // MARK: - FlightManagerDelegate
    
    func updateSPFlight(_ flight: SPFlight?) {
        if let flight = flight {
            self.flight = flight
            self.networkManager.downloadImage(from: URL(string: (flight.flightData![0].mapIdTo!))!)
                DispatchQueue.main.async {
                    self.flightTipsTableView.reloadData()
                }
            }
    }
    
    func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.destinationImage = image
            self.flightTipsTableView.reloadData()
        }
    }
    
    @IBAction func onReload() {
        self.networkManager.getAllSPFlight { (error) in
            if error == nil {
                
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
            
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightTipsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SPFlightTableViewCell
        cell.flightDepartureLabel.text = self.flight?.flightData![indexPath.row].countryFrom?.name
        cell.flightDestinationLabel.text = self.flight?.flightData![indexPath.row].countryTo?.name
        cell.flightImageView.image = self.destinationImage
        return cell
    }
}

