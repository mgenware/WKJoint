//
//  WKJAsyncArgs.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

protocol WKJPromiseProxyDelegate: class {
    func promise(_ promise: WKJPromiseProxy, didResolve data: WKJEncodable?)
    func promise(_ promise: WKJPromiseProxy, didReject error: WKJEncodable?)
}

class WKJPromiseProxy {
    weak var delegate: WKJPromiseProxyDelegate?
    let id: String
    
    init(id: String) {
        self.id = id
    }
    
    func resolve(_ data: WKJEncodable?) {
        delegate?.promise(self, didResolve: data)
    }
    
    func reject(_ error: WKJEncodable?) {
        delegate?.promise(self, didReject: error)
    }
}

