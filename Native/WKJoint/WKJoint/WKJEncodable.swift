//
//  WKJEncodable.swift
//  BeePOS
//
//  Created by Mgen on 6/2/18.
//  Copyright © 2018 Mgen. All rights reserved.
//

import UIKit

protocol WKJEncodable {
    func encodeToJSON() -> Data?
}

struct WKJValue<T: Encodable>: WKJEncodable, Encodable {
    var value: T
    
    init(_ value: T) {
        self.value = value
    }
    
    func encodeToJSON() -> Data? {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(self) else {
            return nil
        }
        return jsonData
    }
}
