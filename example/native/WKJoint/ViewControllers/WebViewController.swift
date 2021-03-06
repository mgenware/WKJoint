//
//  WebViewController.swift
//  WKJoint
//
//  Created by Mgen on 17/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: ViewController {
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupWebView()
        loadDemoPage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupWebView() {
        // view-related
        GlobalTime.log("start creating WebView")
        webView = WKWebView(frame: view.bounds)
        GlobalTime.log("end creating WebView")
        view.addSubview(webView)
        
        // set delegates
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        // setup custom user agent
        WKJUserAgent.updateUserAgent(webView: webView)
        
        // setup JavaScript APIs
        let namespaces = [
            AlertNamespace(),
            MathNamespace(),
            FactoryNamespace(),
        ]
        let apiStore = WKJAPIStore(namespaces: namespaces)
        apiStore.mount(self)
        
        // inject runtime files
        webView.configuration.userContentController.addUserScript(WKJRuntime.wkUserScript())
    }
    
    deinit {
        GlobalTime.log("WebViewController deinited")
    }

}

// MARK: - Demo Page
extension WebViewController {
    private func loadDemoPage() {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "playground", ofType: "html", inDirectory: "DemoPage")!)
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
}

// MARK: - WKJContextProtocol
extension WebViewController: WKJContextProtocol {
    var viewControllerInstance: UIViewController? {
        return self
    }
    
    var webViewInstance: WKWebView {
        return webView
    }
}
