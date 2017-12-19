//
//  WKJIncomingCallError.swift
//  WKJoint
//
//  Created by Mgen on 19/12/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

class WKJIncomingCallError: LocalizedError {
    private var msg: String
    
    init(_ msg: String) {
        self.msg = msg
    }
    
    var description: String {
        get {
            return msg
        }
    }
    
    var errorDescription: String? {
        get {
            return self.description
        }
    }
}

