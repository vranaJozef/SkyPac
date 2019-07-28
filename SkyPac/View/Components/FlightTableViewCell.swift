//
//  SPFlightTableViewCell.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var flightDepartureLabel: UILabel!
    @IBOutlet weak var flightArrivalLabel: UILabel!
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var price: UILabel!
    
    func configure(_ item: FlightData?) {
        if let route = item?.route {
            self.flightDepartureLabel.text = route.first?.cityFrom
            self.flightArrivalLabel.text = route.last?.cityTo
        }
        self.departureDate.text = Date().ddmmYYYYFormatter()
        let locale = NSLocale(localeIdentifier: "EUR")
        let currencySymbol = locale.displayName(forKey: NSLocale.Key.currencySymbol, value: "EUR")
        if let conversion = item?.conversion?.currency {
            self.price.text = String("\(conversion)\(currencySymbol!)")
        }
        let key = item?.mapIdTo
        if let placeholderImage = UIImage(named: "placeholderImage") {
            self.flightImageView.imageFromServerURL("https://images.kiwi.com/photos/610x251/\(key!).jpg", placeHolder: placeholderImage)
        }
    }
}
