//
//  WKJConfiguration.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit


class WKJConfiguration: NSObject {
    // you should not use this property directly
    fileprivate var nsMap: [String: WKJNamespace] = [String: WKJNamespace]()
    
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
    
    func addToUserContentController(_ userContentController: WKUserContentController) {
        for (key, val) in nsMap {
            userContentController.add(val, name: key)
        }
    }
}

