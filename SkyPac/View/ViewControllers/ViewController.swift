//
//  ViewController.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FlightManagerDelegate {

    @IBOutlet weak var flightsTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let cellID = "flightCell"
    let networkManager = FlightManager()
    var flight: [FlightData]?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flightsTableView.register(UINib(nibName: "FlightTableViewCell", bundle: nil), forCellReuseIdentifier: cellID)
        networkManager.delegate = self
        self.activityIndicator.startAnimating()
        if Reachability.isConnectedToNetwork() {
            self.networkManager.getAllFlights { (error) in
                if let error = error {
                    self.handleError(error: error)
                }
            }
        } else {
            self.handleError(error: .noInternetConnection)
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.flightsTableView.isHidden = false
            self.flightsTableView.reloadData()
        }
    }

    func handleError(error: WebError<APIError>) {
        self.activityIndicator.stopAnimating()
        self.flightsTableView.isHidden = true
        self.errorLabel.text = error.localizedDescription
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "flightDetail" {
            let flightDetailVC = segue.destination as! FlightDetailVC
            if let flight = self.flight {
                let indexPath = sender as! IndexPath
                flightDetailVC.currentFlightInfo = flight[indexPath.row]
            }
        }
    }
    
    // MARK: - FlightManagerDelegate
    
    func updateFlight(_ flight: [FlightData]?) {
        if let flight = flight {
            self.flight = flight            
            self.updateUI()
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.flight?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FlightTableViewCell
        cell.configure(self.flight?[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flightsTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "flightDetail", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.view.frame.height * 0.5
        return height
    }
}

