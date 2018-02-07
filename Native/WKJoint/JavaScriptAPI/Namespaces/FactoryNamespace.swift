//
//  FactoryNamespace.swift
//  WKJoint
//
//  Created by Mgen on 16/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

struct Person: Encodable {
    var id: Int
    var name: String
}

class FactoryNamespace: WKJNamespace {
    init() {
        super.init(name: "factory")
        
        addFunc("array", array)
        addFunc("object", object)
    }
    
    private func array(args: WKJArgs) -> WKJEncodable? {
        return WKJValue([1, 2, 3])
    }
    
    private func object(args: WKJArgs) -> WKJEncodable? {
        let person = Person(id: 123, name: "Mgen")
        
        return WKJValue(person)
    }
}

