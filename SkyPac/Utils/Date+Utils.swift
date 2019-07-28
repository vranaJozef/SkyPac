//
//  DateFormatter.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 26/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

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

public extension JSONDecoder {
    
    private static let nestedModelKeyPathCodingUserInfoKey = CodingUserInfoKey(rawValue: "nested_model_keypath")!
    
    private struct Key: CodingKey {
        let stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = nil
        }
        
        let intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    
    private struct ModelResponse<TargetModel: Decodable>: Decodable {
        let model: TargetModel
        
        init(from decoder: Decoder) throws {
            // Split nested paths with '.'
            var keyPaths = (decoder.userInfo[JSONDecoder.nestedModelKeyPathCodingUserInfoKey]! as! String).split(separator: ".")
            
            // Get last key to extract in the end
            let lastKey = String(keyPaths.popLast()!)
            
            // Loop getting container until reach final one
            var targetContainer = try decoder.container(keyedBy: Key.self)
            for k in keyPaths {
                let key = Key(stringValue: String(k))!
                targetContainer = try targetContainer.nestedContainer(keyedBy: Key.self, forKey: key)
            }
            model = try targetContainer.decode(TargetModel.self, forKey: Key(stringValue: lastKey)!)
        }
    }
    
    /// Decodes a model T from json data with the given keypath.
    func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
        self.userInfo[JSONDecoder.nestedModelKeyPathCodingUserInfoKey] = keyPath
        return try self.decode(ModelResponse<T>.self, from: data).model
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
}
