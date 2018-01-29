//
//  WKJNamespace.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

// defines a namespace object
class WKJNamespace: NSObject {    
    let name: String
    private var funcs: [String: WKJFuncProtocol] = [String: WKJFuncProtocol]()
    
    init(name: String) {
        self.name = name
    }
    
    // adds a sync style func to this namespace
    func addFunc(_ name: String, _ fn: @escaping WKJFunc) {
        checkNotExist(fnName: name)
        funcs[name] = SyncFunc(name: name, value: fn)
    }
    
    // adds an async style func to this namespace
    func addAsyncFunc(_ name: String, _ fn: @escaping WKJAsyncFunc) {
        checkNotExist(fnName: name)
        funcs[name] = AsyncFunc(name: name, value: fn)
    }
    
    subscript(key: String) -> WKJFuncProtocol? {
        get {
            return funcs[key]
        }
    }
    
    private func checkNotExist(fnName: String) {
        if funcs[fnName] != nil {
            assertionFailure("\(fnName) already exists")
        }
    }
}

