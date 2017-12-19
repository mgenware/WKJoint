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
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        
        // implement UI Delegate
        webView.uiDelegate = self
        
        // setup custom user agent
        WKJUserAgent.updateUserAgent(webView: webView)
        
    }
    
    deinit {
        print("WebViewController deinited")
    }

}

extension WebViewController {
    private func loadDemoPage() {
        let url = Bundle.main.url(forResource: "playground", withExtension: "html", subdirectory: "DemoPage")
        let htmlString = try! String(contentsOf: url!, encoding: .utf8)
        webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL.appendingPathComponent("DemoPage", isDirectory: true))
    }
}

extension WebViewController: WKJContextProtocol {
    var viewControllerInstance: UIViewController? {
        return self
    }
    
    var webViewInstance: WKWebView {
        return webView
    }
    
}

// Mark: - WKUIDelegate
extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (Bool) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            completionHandler(nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
}

