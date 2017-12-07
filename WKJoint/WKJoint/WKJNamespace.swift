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
    func addAsycFunc(_ name: String, _ fn: @escaping WKJAsyncFunc) {
        checkNotExist(fnName: name)
        funcs[name] = AsyncFunc(name: name, value: fn)
    }
    
    private func checkNotExist(fnName: String) {
        if funcs[fnName] != nil {
            assertionFailure("\(fnName) already exists")
        }
    }
}

// MARK: - WKScriptMessageHandler
extension WKJNamespace: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? Dictionary<String, Any> else {
            logWarning("Invalid body received")
            return
        }
        
        guard let promiseID = body["promiseID"] as? String else {
            logWarning("Invalid promiseID received")
            return
        }
        
        guard let funcName = body["func"] as? String else {
            logWarning("Empty function name")
            return
        }
        
        guard let fn = funcs[funcName] else {
            resolvePromise(id: promiseID, data: nil, error: "Func \"\(funcName)\" is not defined")
            return
        }
        
        let bodyDictionary = body["arg"] as? [String: Any] ?? [:]
        let args = WKJArgs(id: promiseID, dictionary: bodyDictionary)
        if fn is SyncFunc {
            let syncFn = fn as! SyncFunc
            do {
                
                let result = try syncFn.value(args)
                resolvePromise(id: promiseID, data: result, error: nil)
            } catch {
                resolvePromise(id: promiseID, data: nil, error: error)
            }
        } else {
            let asyncFn = fn as! AsyncFunc
            let promiseProxy = WKJPromiseProxy(id: promiseID)
            promiseProxy.delegate = self
            
            asyncFn.value(args, promiseProxy)
        }
        
    }
    
    private func logWarning(_ msg: String) {
        print("WKJoint Warning: \(msg)")
    }
    
    private func resolvePromise(id: String, data: Any?, error: Any?) {
        let dataJS = dataToJSON(data)
        let errorJS = dataToJSON(error)
        let js = "window.__WKJoint.endPromise(\"\(id)\", \(dataJS), \(errorJS))"
        delegate?.namespace(self, didRequestJavaScriptCall: js)
    }
    
    private func dataToJSON(_ data: Any?) -> String {
        guard let data = data else {
            return JS_UNDEFINED
        }
        do {
            var any: Any
            if data is Error {
                any = (data as! Error).localizedDescription
            } else {
                any = data
            }
            let raw = try JSONSerialization.data(withJSONObject: ["default": any], options: [])
            return String(bytes: raw, encoding: .utf8) ?? JS_UNDEFINED
        } catch {
            return JS_UNDEFINED
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
