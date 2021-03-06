//
//  WKJScriptMessageHandler.swift
//  WKJoint
//
//  Created by Mgen on 19/12/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

protocol WKJScriptMessageHandlerDelegate: class {
    // Incoming call error defines errors occurred during parsing an incoming call from JavaScript
    func scriptMessageHandler(_ scriptMessageHandler: WKJScriptMessageHandler, didReceiveIncomingCallError error: Error)
    // Outgoing call error defines errors occurred during injecting a JavaScript expression to WKWebView
    func scriptMessageHandler(_ scriptMessageHandler: WKJScriptMessageHandler, didReceiveOutgoingCallError error: Error)
}

class WKJScriptMessageHandler: NSObject {
    // constants
    let JS_UNDEFINED = "undefined"
    // readonly props
    let namespace: WKJNamespace
    // weak props
    weak var context: WKJContextProtocol?
    weak var delegate: WKJScriptMessageHandlerDelegate?
    
    init(context: WKJContextProtocol, namespace: WKJNamespace) {
        self.context = context
        self.namespace = namespace
    }
}

// MARK: - WKScriptMessageHandler
extension WKJScriptMessageHandler: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? Dictionary<String, Any> else {
            emitIncomingWarning(WKJCallError("Invalid body"))
            return
        }
        
        guard let promiseID = body["promiseID"] as? String else {
            emitIncomingWarning(WKJCallError("Invalid Promise ID"))
            return
        }
        
        guard let funcName = body["func"] as? String else {
            emitIncomingWarning(WKJCallError("Empty function name"))
            return
        }
        
        guard let fn = namespace[funcName] else {
            resolvePromise(id: promiseID, data: nil, error: WKJValue("Func \"\(funcName)\" is not defined"))
            return
        }
        
        let bodyDictionary = body["arg"] as? [String: Any] ?? [:]
        let args = WKJArgs(id: promiseID, dictionary: bodyDictionary, context: context)
        if fn is SyncFunc {
            let syncFn = fn as! SyncFunc
            do {
                let result = try syncFn.value(args)
                resolvePromise(id: promiseID, data: result, error: nil)
            } catch {
                resolvePromise(id: promiseID, data: nil, error: WKJValue(error.localizedDescription))
            }
        } else {
            let asyncFn = fn as! AsyncFunc
            let promiseProxy = WKJPromiseProxy(id: promiseID)
            promiseProxy.delegate = self
            
            asyncFn.value(args, promiseProxy)
        }
    }
}

// MARK: - Promise
extension WKJScriptMessageHandler {
    private func resolvePromise(id: String, data: WKJEncodable?, error: WKJEncodable?) {
        let dataJS = dataToJSON(data)
        let errorJS = dataToJSON(error)
        let js = "window.__WKJoint.endPromise(\"\(id)\", \(dataJS), \(errorJS))"
        
        guard let webView = context?.webViewInstance else {
            self.emitOutgoingWarning(WKJCallError("WebView is nil"))
            return
        }
        webView.evaluateJavaScript(js, completionHandler: { (_, error) in
            if let error = error {
                self.emitOutgoingWarning(error)
            }
        })
    }
    
    private func dataToJSON(_ encodable: WKJEncodable?) -> String {
        guard let jsonData = encodable?.encodeToJSON() else {
            return JS_UNDEFINED
        }
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            return JS_UNDEFINED
        }
        
        return jsonString
    }
}

// MARK: - Delegate
extension WKJScriptMessageHandler {
    private func emitIncomingWarning(_ error: Error) {
        delegate?.scriptMessageHandler(self, didReceiveIncomingCallError: error)
    }
    
    private func emitOutgoingWarning(_ error: Error) {
        delegate?.scriptMessageHandler(self, didReceiveOutgoingCallError: error)
    }
}

// MARK: - WKJPromiseProxyDelegate
extension WKJScriptMessageHandler: WKJPromiseProxyDelegate {
    func promise(_ promise: WKJPromiseProxy, didResolve data: WKJEncodable?) {
        resolvePromise(id: promise.id, data: data, error: nil)
    }
    
    func promise(_ promise: WKJPromiseProxy, didReject error: WKJEncodable?) {
        resolvePromise(id: promise.id, data: nil, error: error)
    }
}

