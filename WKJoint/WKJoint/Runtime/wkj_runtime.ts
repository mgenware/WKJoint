 /*************************************************************************
 * 
 * WKJoint Runtime.ts
 * github.com/mgenware/WKJoint
 * @ 2017 Mgen
 * 
 * This is the source code of runtime.js. It should NOT be included in "Copy Bundle Resources"!
 * Use `tsc` to compile this file.
 * 
 * Inspired by http://igomobile.de/2017/03/06/wkwebview-return-a-value-from-native-code-to-javascript/
 */

class DelayedPromise<T> {
  resolve: (value?: T | PromiseLike<T>) => void;
  reject: (reason?: any) => void;
}

class WKJCall {
  constructor(public promiseID: string, public func: string, public arg: any) {}
}

class WKJointRuntime {
  promises: { [id: string]: DelayedPromise<any>; } = {};

  beginPromise(ns: string|null, func: string|null, arg: any): Promise<any>|null {
    if (!ns || !func) {
      return null;
    }

    const promise = new Promise((resolve, reject) => {
      const id = this.uuidv4();
      const delayedPromise = new DelayedPromise();
      delayedPromise.resolve = resolve;
      delayedPromise.reject = reject;
      this.promises[id] = delayedPromise;
       
      try {
        const wind = window as any;
        if (wind.webkit && wind.webkit.messageHandlers) {
          const handler = wind.webkit.messageHandlers[ns];
          if (handler && typeof handler.postMessage === 'function') {
            const call = new WKJCall(id, func, arg);
            handler.postMessage(call)
          }
        }
      }
      catch(exception) {
        alert(exception);
      }
       
    });
    return promise;
  }

  endPromise(id: string, data: any, error: any) {
    const delayedPromise = this.promises[id];
    if (!delayedPromise) {
      return;
    }
    if (error) {
      delayedPromise.reject(error);
    } else {
      delayedPromise.resolve(data ? data.default : undefined);
    }
    // remove reference
    delete this.promises[id];
  }

  // https://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
  private uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
}

const wind = window as any;
if (!wind.__WKJoint) {
  wind.__WKJoint = new WKJointRuntime();
}