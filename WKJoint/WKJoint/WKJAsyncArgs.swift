//
//  WKJAsyncArgs.swift
//  WKJoint
//
//  Created by Mgen on 9/21/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

protocol WKJAsyncArgsDelegate: class {
    func args(_ args: WKJAsyncArgs, didResolve data: Any?)
    func args(_ args: WKJAsyncArgs, didReject error: Any?)
}

class WKJAsyncArgs: WKJArgs {
    weak var delegate: WKJAsyncArgsDelegate?
    
    override init(id: String, dictionary: [String: Any]) {
        super.init(id: id, dictionary: dictionary)
    }
    
    func resolve(_ data: Any?) {
        delegate?.args(self, didResolve: data)
    }
    
    func reject(_ error: Any?) {
        delegate?.args(self, didReject: error)
    }
}
