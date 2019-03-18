//
//  WKJFunc.swift
//  WKJoint
//
//  Created by Mgen on 19/12/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

// Func type for a sync func
typealias WKJFunc = (_ args: WKJArgs) throws -> WKJEncodable?
// Func type for an async func
typealias WKJAsyncFunc = (_ args: WKJArgs, _ promise: WKJPromiseProxy) -> Void

// defines the type used to store an API func
protocol WKJFuncProtocol {
    var name: String { get }
}

struct SyncFunc: WKJFuncProtocol {
    let name: String
    let value: WKJFunc
}

struct AsyncFunc: WKJFuncProtocol {
    let name: String
    let value: WKJAsyncFunc
}
