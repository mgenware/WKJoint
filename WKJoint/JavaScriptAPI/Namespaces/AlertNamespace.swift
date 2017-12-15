//
//  AlertNamespace.swift
//  WKJoint
//
//  Created by Mgen on 16/12/2017.
//  Copyright © 2017 Mgen. All rights reserved.
//

import UIKit

class AlertNamespace: WKJNamespace {
    init() {
        super.init(name: "alert")
        
        addAsyncFunc("sheetAsync", sheetAsync)
    }

    private func sheetAsync(args: WKJArgs, promise: WKJPromiseProxy) {
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let firstAction: UIAlertAction = UIAlertAction(title: "First", style: .default) { action -> Void in
            promise.resolve("You tapped First")
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "Second", style: .default) { action -> Void in
            
            promise.resolve("You tapped Second")
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            promise.reject("Action cancelled")
        }
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController as! ViewController
        viewController.present(actionSheetController, animated: true, completion: nil)
    }
}
