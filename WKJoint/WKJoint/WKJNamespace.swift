//
//  WKJNamespace.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

typealias WKJAPIFunc = (_ args: WKJAPIArgs) throws -> Any?

protocol WKJNamespaceDelegate {
    func namespace(_ namespace: WKJNamespace, didRequestJavaScriptCall js: String)
}

class WKJNamespace: NSObject {
    let name: String
    private var funcs: [String: WKJAPIFunc] = [String: WKJAPIFunc]()
    
    var delegate: WKJNamespaceDelegate?
    
    init(name: String) {
        self.name = name
    }
    
    subscript(key: String) -> WKJAPIFunc? {
        get {
            return funcs[key]
        }
        set (newValue) {
            funcs[key] = newValue
        }
    }
}

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
        
        guard let fn = self[funcName] else {
            resolvePromise(id: promiseID, data: nil, error: "Func \"\(funcName)\" is not defined")
            return
        }
        
        do {
            let results = try fn(WKJAPIArgs(dictionary: body["arg"] as? [String: Any] ?? [:]))
            resolvePromise(id: promiseID, data: results, error: nil)
        } catch {
            print("Error: \(error)")
            resolvePromise(id: promiseID, data: nil, error: error)
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
            return "null"
        }
        let raw = try? JSONSerialization.data(withJSONObject: data, options: [])
        if let raw = raw {
            return String(bytes: raw, encoding: .utf8) ?? "null"
        }
        return "null";
    }
}
