//
//  DateFormatter.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

extension Date {
    
    private func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter
    }
    
    func ddmmYYYYFormatter() -> String {
        let dateFormatter = self.dateFormatter()
        let formattedString = dateFormatter.string(from: self)
        return formattedString
    }
    
    func addOneDay() -> String? {
        let dateFormatter = self.dateFormatter()
        guard let adjustedDate = Calendar.current.date(byAdding: .day, value: 1, to: self) else { return nil }
        let convertedDate = dateFormatter.string(from: adjustedDate)
        return convertedDate
    }
}
