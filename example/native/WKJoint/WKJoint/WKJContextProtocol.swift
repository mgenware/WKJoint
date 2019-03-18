//
//  WKJContextProtocol.swift
//  WKJoint
//
//  Created by Mgen on 19/12/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit
import WebKit

protocol WKJContextProtocol: class {
    var viewControllerInstance: UIViewController? { get }
    var webViewInstance: WKWebView { get }
}
