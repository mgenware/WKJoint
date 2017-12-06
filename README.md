# WKJoint
JavaScript to Native(Swift) Bridge

## Features
* `Promise` support in JavaScript side.
* Allows to define client function in both async and sync ways.
* Custom UA(User agent) support.

## Sample
Call the API on JavaScript side:
```javascript
window.__WKJoint.beginPromise('json', 'parseAsync', { value: '{ "name": "Mgen", "id": 1 }' })
  .then((res) => {
    console.log(`Succeeded: ${res}`);
  })
  .catch((err) => {
    console.log(`Error occurred: ${err}`);
  });
```

Expose an API in native side:
```swift
// define the namespace
let jsonNS = WKJNamespace(name: "json")
// define a function in an async way
jsonNS.addAsycFunc("parseAsync") { (args) in
    // promise is considered settled either by resolve or reject
    guard let str = args["value"] as? String else {
        args.reject("Invalid argument")
        return
    }
    // wait 3 secs
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

// define a function in a sync way
jsonNS.addFunc("parse") { (args) -> Any? in
    // either return a value or throw an error indicating something goes wrong
    guard let str = args["value"] as? String else {
        throw MyError.RuntimeError("value is not a valid string")
    }
    guard let data = str.data(using: .utf8) else {
        throw MyError.RuntimeError("Invalid data")
    }
    return try JSONSerialization.jsonObject(with: data, options: [])
}
```
