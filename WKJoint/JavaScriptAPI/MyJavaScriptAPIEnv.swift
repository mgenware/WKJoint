//
//  MyJavaScriptAPIEnv.swift
//  WKJoint
//
//  Created by Mgen on 16/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class MyJavaScriptAPIEnv {
    var webView: WKWebView!
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    func setupEnv(namespaces: [WKJNamespace]) {
        // setup namespaces
        let wkjConfig = WKJConfiguration()
        wkjConfig.addNamespaces(namespaces)
        wkjConfig.addToWebView(webView)
       
        // inject runtime script
        webView.configuration.userContentController.addUserScript(WKJRuntime.wkUserScript())
    }
}
