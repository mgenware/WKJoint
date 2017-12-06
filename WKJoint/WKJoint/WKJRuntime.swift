//
//  WKJRuntime.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

class WKJRuntime {
    // returns a WKUserScript object which can be used to inject runtime.js at document start
    static func wkUserScript() -> WKUserScript {
        let runtimeJS = requestRuntimeJS()
        return WKUserScript(source: runtimeJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }
    
    // returns content of runtime.js
    private static func requestRuntimeJS() -> String {
        let path = Bundle.main.path(forResource: "wkj_runtime", ofType: "js")!
        let runtimeJS = try! String(contentsOfFile: path, encoding: .utf8)
        
        return runtimeJS
    }
}
