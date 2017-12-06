//
//  WKJUserAgent.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class WKJUserAgent: NSObject {
    static func updateUserAgent(webView: WKWebView) {
        if #available(iOS 9.0, *) {
            webView.evaluateJavaScript("navigator.userAgent", completionHandler: { (res, err) in
                if err != nil {
                    return
                }
                if let res = res as? String {
                    webView.customUserAgent = res + " " + self.requestUserAgent()
                }
            })
        }
    }
}

extension WKJUserAgent {
    static func requestUserAgent() -> String {
        guard let infoDic = Bundle.main.infoDictionary else {
            return ""
        }
        return "\(infoDic["CFBundleName"] ?? "")/\(infoDic["CFBundleShortVersionString"] ?? "")"
    }
}
