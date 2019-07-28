//
//  URL+Utils.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

extension URL {
    
    func addURLParameters(items: [String:String?]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return self.absoluteURL }
        
        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []
        
        // Create query item
        for (_, itemValue) in items.enumerated() {
            let queryItem = URLQueryItem(name: itemValue.key, value: itemValue.value)
            // Append the new query item in the existing query items array
            queryItems.append(queryItem)
        }
        
        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return self.absoluteURL }
        return url
    }
}

