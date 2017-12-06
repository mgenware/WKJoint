//
//  WKJArgs.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

// Type of arguments for a sync func
class WKJArgs {
    let id: String
    let dictionary: [String: Any];
    
    init(id: String, dictionary: [String: Any]) {
        self.id = id
        self.dictionary = dictionary
    }
    
    subscript(key: String) -> Any? {
        get {
            return dictionary[key]
        }
    }
}

// MARK: - CustomStringConvertible
extension WKJArgs: CustomStringConvertible {
    var description: String {
        return dictionary.description
    }
}
