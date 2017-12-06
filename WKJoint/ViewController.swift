//
//  ViewController.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupWebView()
        
        WKJUserAgent.updateUserAgent(webView: webView)
        
        let url = Bundle.main.url(forResource: "playground", withExtension: "html", subdirectory: "Playground")
        let htmlString = try! String(contentsOf: url!, encoding: .utf8)
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL.appendingPathComponent("Playground", isDirectory: true))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupWebView() {
        let webViewConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: view.bounds, configuration: webViewConfig)
        view.addSubview(webView)
        
        let deviceNS = WKJNamespace(name: "device")
        deviceNS["osVer"] = { (args) -> Any? in
            print("args: ", args)
            return nil
        }
        
        let wkjConfig = WKJConfiguration()
        wkjConfig.addNamespaces([deviceNS])
        wkjConfig.addToUserContentController(webViewConfig.userContentController)
        webViewConfig.userContentController.addUserScript(WKJRuntime.wkUserScript())
    }
}

