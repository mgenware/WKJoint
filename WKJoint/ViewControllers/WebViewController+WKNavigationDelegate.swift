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
        GlobalTime.log("Navigation started: \(navigationAction.request)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GlobalTime.log("Navigation succeeded")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        GlobalTime.log("Navigation failed")
    }
}
