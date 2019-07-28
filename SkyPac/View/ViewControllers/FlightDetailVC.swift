//
//  FlightDetailVC.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 28/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class FlightDetailVC: UIViewController {
    
    @IBOutlet weak var arrivalImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var flightInfoTableView: UITableView!
    let cellID = "flightDetailCell"
    var tableData = [String: String?]()
    var currentFlightInfo: FlightData?
    var tableDataKeys = [String]()
    var currency: String?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let flight = currentFlightInfo {
            let vm = FlightDetailVM.init(flight)
            vm.update()
            self.currency = vm.currency
            self.price.text = vm.price
            let key = flight.mapIdTo
            self.arrivalImage.imageFromServerURL("https://images.kiwi.com/photos/610x251/\(key!).jpg", placeHolder: nil)
        }
            self.handleTableData()        
    }
    
    // MARK: - Actions
    
    @IBAction func addToCalendar(_ sender: UIButton) {
        if let flight = self.currentFlightInfo {
            if let departure = flight.route?.first?.cityFrom,
                let arrival = flight.route?.last?.cityTo,
                let startTime = flight.departureTimeUTC?.toDate(),
                let arrivalTime = flight.arrivalTimeUTC?.toDate() {
                self.addEventToCalendar(title: departure + " " + arrival, description: nil, startDate: startTime, endDate: arrivalTime)
            }
        }
    }
    
    // MARK : - Private
    
   private func handleTableData() {
        if let flight = currentFlightInfo {
            self.tableData["Departure city"] = flight.route?.first?.cityFrom ?? ""
            self.tableData["Arrival city"] = flight.route?.last?.cityTo ?? ""
            self.tableData["Fly duration"] = flight.flyDuration ?? ""
            self.tableData["Departure time"] = flight.departureTimeUTC?.ddMMYYYYFormatter() ?? nil
            self.tableData["Arrival time"] = flight.arrivalTimeUTC?.ddMMYYYYFormatter() ?? nil
            if let currency = self.currency {
                if let smallBags = flight.baggage?.small?.toString() {
                    self.tableData["Small bags price"] = smallBags + currency
                }
                if let bigBags = flight.baggage?.big?.toString() {
                    self.tableData["Big bags price"] = bigBags + currency
                }
            }
        }
        self.tableDataKeys = Array(self.tableData.keys)
        self.tableDataKeys.sort(by: {$0 < $1})
    }
}

extension FlightDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for (_, item) in tableData.enumerated() {
            if item.value == nil {
                self.tableData.removeValue(forKey: item.key)
            }
        }
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.flightInfoTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let rowTitle = self.tableDataKeys[indexPath.row]
        cell.textLabel?.text = rowTitle
        cell.detailTextLabel?.text = self.tableData[rowTitle] ?? ""
        return cell
    }
}

extension FlightDetailVC: EKEventEditViewDelegate {
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date) {
        let eventStore = EKEventStore()
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            }
        })
    }
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
