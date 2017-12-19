//
//  WKJError.swift
//  WKJoint
//
//  Created by Mgen on 16/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

class WKJError: LocalizedError {
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
