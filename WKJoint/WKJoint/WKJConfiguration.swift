//
//  WKJConfiguration.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class WKJConfiguration {
    // you should not use this property directly
    private var nsMap: [String: WKJNamespace] = [String: WKJNamespace]()
    
    private weak var webView: WKWebView?
    
    func addNamespaces(_ namespaces: [WKJNamespace]) {
        for ns in namespaces {
            if nsMap[ns.name] != nil {
                assertionFailure("The namespace \"\(ns.name)\" is added twice")
            }
            
            nsMap[ns.name] = ns
        }
    }
    
    func namespace(forKey: String) -> WKJNamespace? {
        return nsMap[forKey]
    }
    
    func addToWebView(_ webView: WKWebView) {
        self.webView = webView
        for (key, val) in nsMap {
            val.delegate = self
            webView.configuration.userContentController.add(val, name: key)
        }
    }
}

// MARK: WKJNamespaceDelegate
extension WKJConfiguration: WKJNamespaceDelegate {
    func namespace(_ namespace: WKJNamespace, didRequestJavaScriptCall js: String) {
        webView?.evaluateJavaScript(js, completionHandler: { (_, error) in
            if let error = error {
                print("Error occurred in WKJConfiguration.didRequestJavaScriptCall: \(error)")
            }
        })
    }
}
