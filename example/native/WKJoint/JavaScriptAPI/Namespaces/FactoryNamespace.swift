//
//  FactoryNamespace.swift
//  WKJoint
//
//  Created by Mgen on 16/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

struct Pet: Encodable {
    var name: String
    var type: String
}

struct Person: Encodable {
    var id: Int
    var name: String
    var pets: [Pet]
}

class FactoryNamespace: WKJNamespace {
    init() {
        super.init(name: "factory")
        
        addFunc("array", array)
        addFunc("encodableObject", encodableObject)
    }
    
    private func array(args: WKJArgs) -> WKJEncodable? {
        return WKJValue([1, 2, 3])
    }
    
    private func encodableObject(args: WKJArgs) -> WKJEncodable? {
        let pets = [Pet(name: "Wenhao", type: "dog"), Pet(name: "Dage", type: "cat")]
        let person = Person(id: 123, name: "Mgen", pets: pets)
        
        return WKJValue(person)
    }
}

