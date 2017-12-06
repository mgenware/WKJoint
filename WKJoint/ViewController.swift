//
//  ViewController.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

enum MyError : Error {
    case RuntimeError(String)
}

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
        
        webView.uiDelegate = self
        
        let jsonNS = WKJNamespace(name: "json")
        jsonNS.addAsycFunc("parseAsync") { (args) in
            guard let str = args["value"] as? String else {
                args.reject("Invalid argument")
                return
            }
            // wait 3 sec
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                guard let data = str.data(using: .utf8) else {
                    args.reject("Encoding error")
                    return
                }
                
                do {
                    let obj = try JSONSerialization.jsonObject(with: data, options: [])
                    args.resolve(obj)
                } catch {
                    args.reject(error)
                }
            })
        }
        
        jsonNS.addFunc("parse") { (args) -> Any? in
            let str = args["value"] as! String
            guard let data = str.data(using: .utf8) else {
                throw MyError.RuntimeError("Invalid data")
            }
            return try JSONSerialization.jsonObject(with: data, options: [])
        }
        
        let wkjConfig = WKJConfiguration()
        wkjConfig.addNamespaces([jsonNS])
        wkjConfig.addToWebView(webView)
        webViewConfig.userContentController.addUserScript(WKJRuntime.wkUserScript())
    }
}

extension ViewController: WKUIDelegate {
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


