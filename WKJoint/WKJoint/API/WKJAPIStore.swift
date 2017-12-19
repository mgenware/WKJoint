//
//  WKJAPIStore.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class WKJAPIStore {
    // stores all namespace objects, you should not use this property directly
    private var nsMap: [String: WKJNamespace] = [String: WKJNamespace]()
    
    init(namespaces: [WKJNamespace]) {
        addNamespaces(namespaces)
    }
    
    // returns a namespace by a given key
    func namespace(forKey: String) -> WKJNamespace? {
        return nsMap[forKey]
    }
    
    // mounts all namespaces to WebView's configuration controller
    func mount(_ context: WKJContextProtocol) {
        for (key, namespace) in nsMap {
            let scriptHandler = WKJScriptMessageHandler(context: context, namespace: namespace)
            context.webViewInstance.configuration.userContentController.add(scriptHandler, name: key)
        }
    }
}

// MARK: - Private funcs
extension WKJAPIStore {
    // adds a list of namespaces to internal map
    func addNamespaces(_ namespaces: [WKJNamespace]) {
        for ns in namespaces {
            if nsMap[ns.name] != nil {
                assertionFailure("The namespace \"\(ns.name)\" is added twice")
            }
            
            nsMap[ns.name] = ns
        }
    }
}
