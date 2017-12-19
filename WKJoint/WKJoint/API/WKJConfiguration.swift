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
    // stores all namespace objects, you should not use this property directly
    private var nsMap: [String: WKJNamespace] = [String: WKJNamespace]()
    
    // adds a list of namespaces to internal map
    func addNamespaces(_ namespaces: [WKJNamespace]) {
        for ns in namespaces {
            if nsMap[ns.name] != nil {
                assertionFailure("The namespace \"\(ns.name)\" is added twice")
            }
            
            nsMap[ns.name] = ns
        }
    }
    
    // returns a namespace by a given key
    func namespace(forKey: String) -> WKJNamespace? {
        return nsMap[forKey]
    }
    
    // mounts all namespaces to WebView's configuration controller
    func addToWebView(_ webView: WKWebView) {
        for (key, val) in nsMap {
            val.delegate = webView
            webView.configuration.userContentController.add(val, name: key)
        }
    }
}

// MARK: WKJNamespaceDelegate
extension WKWebView: WKJNamespaceDelegate {
    func namespace(_ namespace: WKJNamespace, didRequestJavaScriptCall js: String) {
        evaluateJavaScript(js, completionHandler: { (_, error) in
            if let error = error {
                print("Error occurred in WKJConfiguration.didRequestJavaScriptCall: \(error)")
            }
        })
    }
}
