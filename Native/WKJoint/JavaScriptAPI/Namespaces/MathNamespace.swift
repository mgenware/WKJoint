//
//  MathNamespace.swift
//  WKJoint
//
//  Created by Mgen on 16/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

class MathNamespace: WKJNamespace {
    init() {
        super.init(name: "math")
        
        addFunc("add", add)
    }
    
    private func add(args: WKJArgs) throws -> Any? {
        guard let x = args["x"] as? Int64 else {
            throw WKJError("x is not a valid number")
        }
        guard let y = args["y"] as? Int64 else {
            throw WKJError("y is not a valid number")
        }
        return x + y
    }
}
