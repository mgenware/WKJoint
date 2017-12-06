//
//  WKJArgs.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

protocol WKJArgsDelegate {
    func args(_ args: WKJArgs, didResolve data: Any?)
    func args(_ args: WKJArgs, didReject error: Any?)
}

class WKJArgs {
    var delegate: WKJArgsDelegate?
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
    
    func resolve(_ data: Any?) {
        delegate?.args(self, didResolve: data)
    }
    
    func reject(_ error: Any?) {
        delegate?.args(self, didReject: error)
    }
}

extension WKJArgs: CustomStringConvertible {
    var description: String {
        return dictionary.description
    }
}
