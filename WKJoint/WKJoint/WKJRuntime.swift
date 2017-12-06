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
    static func wkUserScript() -> WKUserScript {
        let runtimeJS = requestRuntimeJS()
        return WKUserScript(source: runtimeJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
    }
    
    private static func requestRuntimeJS() -> String {
        let path = Bundle.main.path(forResource: "wkj_runtime", ofType: "js")!
        let runtimeJS = try! String(contentsOfFile: path, encoding: .utf8)
        
        return runtimeJS
    }
}
