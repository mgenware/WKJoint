//
//  WKJNamespace.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

// Func type for a sync func
typealias WKJFunc = (_ args: WKJArgs) throws -> Any?
// Func type for an async func
typealias WKJAsyncFunc = (_ args: WKJArgs, _ promise: WKJPromiseProxy) -> Void

protocol WKJNamespaceDelegate: class {
    func namespace(_ namespace: WKJNamespace, didRequestJavaScriptCall js: String)
}

// defines the type used to store an API func
protocol WKJFuncProtocol {
    var name: String { get }
}

// defines a namespace object
class WKJNamespace: NSObject {
    struct SyncFunc: WKJFuncProtocol {
        let name: String
        let value: WKJFunc
    }
    struct AsyncFunc: WKJFuncProtocol {
        let name: String
        let value: WKJAsyncFunc
    }
    
    let JS_UNDEFINED = "undefined"
    let name: String
    private var funcs: [String: WKJFuncProtocol] = [String: WKJFuncProtocol]()
    
    weak var delegate: WKJNamespaceDelegate?
    
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
    
    private func checkNotExist(fnName: String) {
        if funcs[fnName] != nil {
            assertionFailure("\(fnName) already exists")
        }
    }
}



// MARK: - WKJArgsDelegate
extension WKJNamespace: WKJPromiseProxyDelegate {
    func promise(_ promise: WKJPromiseProxy, didResolve data: Any?) {
        resolvePromise(id: promise.id, data: data, error: nil)
    }
    
    func promise(_ promise: WKJPromiseProxy, didReject error: Any?) {
        resolvePromise(id: promise.id, data: nil, error: error)
    }
}
