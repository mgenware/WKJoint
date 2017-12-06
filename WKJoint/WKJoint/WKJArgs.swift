//
//  WKJArgs.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

class WKJArgs {
    let dictionary: [String: Any];
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    subscript(key: String) -> Any? {
        get {
            return dictionary[key]
        }
    }
}

extension WKJArgs: CustomStringConvertible {
    var description: String {
        return dictionary.description
    }
}
