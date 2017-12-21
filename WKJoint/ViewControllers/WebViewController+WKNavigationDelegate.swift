//
//  WebViewController+WKNavigationDelegate.swift
//  WKJoint
//
//  Created by Yuanyuan Liu on 21/12/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        GlobalTime.log("navigationAction \(navigationAction.request)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GlobalTime.log("didFinishNavigation \(navigation)")
    }
}
