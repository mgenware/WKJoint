# WKJoint

JavaScript to Native(Swift) Bridge

## Features

* `Promise` based API in JavaScript side.
* Runtime automatically injected to WebView, no need to import extra script files.
* Define native implementations in both async and sync ways.
* Custom user agent support.

## Example
JavaScript side:
```javascript
const api = window.MyJavaScriptAPI;
if (api) {
  // call a math.add function implemented in native side
  api.math.add({
    x: -3, y: 120,
  })
  .then((res) => {
    console.log(`Succeeded: ${res}`);
  })
  .catch((err) => {
    console.log(`Error occurred: ${err}`);
  });

  // display an iOS action sheet
  api.alert.sheetAsync()
  .then((res) => {
    console.log(`Succeeded: ${res}`);
  })
  .catch((err) => {
    console.log(`Error occurred: ${err}`);
  });
}

```

Native side:
```swift
// implement math.add in sync style
class MathNamespace: WKJNamespace {
    init() {
        super.init(name: "math")
        
        addFunc("add", add)
    }
    
    private func add(args: WKJArgs) throws -> Any? {
        guard let x = args["x"] as? Int64 else {
            throw WKJError("x is not a valid number")
        }
        guard let y = args["y"] as? Int64 else {
            throw WKJError("y is not a valid number")
        }
        return x + y
    }
}

// implement alert.sheetAsync in async style
class AlertNamespace: WKJNamespace {
    init() {
        super.init(name: "alert")
        
        addAsyncFunc("sheetAsync", sheetAsync)
    }

    private func sheetAsync(args: WKJArgs, promise: WKJPromiseProxy) {
        // create UIAlertController
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        // add actions
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
        
        // display the action sheet
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewController = appDelegate.window!.rootViewController as! ViewController
        viewController.present(actionSheetController, animated: true, completion: nil)
    }
}
```

## JavaScript Runtime

### Building the Runtime
To build the JavaScript runtime, navigate to `JavaScript` folder, run:
```sh
# install dependencies
yarn
# start building
yarn build
```

Rollup.js is used to bundle all TypeScript files to `dist/js_api_bundle.js`. TypeScript definition files are also generated to `dist` folder.
