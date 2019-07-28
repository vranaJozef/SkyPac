//
//  SPFlightTableViewCell.swift
//  SkyPac
//
//  Created by Jozef Vrana on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import UIKit

class SPFlightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var flightDepartureLabel: UILabel!
    @IBOutlet weak var flightArrivalLabel: UILabel!
    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var flightDepartureTime: UILabel!
    @IBOutlet weak var flightArrivalTime: UILabel!
    @IBOutlet weak var price: UILabel!
}
