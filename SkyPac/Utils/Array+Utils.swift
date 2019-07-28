//
//  Array+Utils.swift
//  SkyPac
//
//  Created by Vrana, Jozef on 28/07/2019.
//  Copyright © 2019 Jozef Vrana. All rights reserved.
//

import Foundation

extension Array {
    func removeDuplicates<S: Sequence, E: Hashable>(source: S) -> [E] where E==S.Iterator.Element {
        var seen: [E:Bool] = [:]
        return source.filter({ (v) -> Bool in
            return seen.updateValue(true, forKey: v) == nil
        })
    }
}
