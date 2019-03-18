//
//  GlobalTime.swift
//  WKJoint
//
//  Created by Mgen on 21/12/17.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

class GlobalTime: NSObject {
    static func log(_ title: String) {
        let ts = DispatchTime.now().rawValue / 1_000_000
        print("🚕 \(ts): \(title)")
    }
}
