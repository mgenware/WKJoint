 /*************************************************************************
 * 
 * WKJoint Runtime.ts
 * github.com/mgenware/WKJoint
 * @ 2017 Mgen
 * 
 * This is the source code of runtime.js. It should NOT be included in "Copy Bundle Resources"!
 * 
 * Inspired by http://igomobile.de/2017/03/06/wkwebview-return-a-value-from-native-code-to-javascript/
 */

class DelayedPromise<T> {
  constructor(
    public resolve: (value?: T | PromiseLike<T>) => void,
    public reject: (reason?: any) => void
  ) { }
}

class WKJCall {
  constructor(public promiseID: string, public func: string, public arg: any) {}
}

class WKJointRuntime {
  devMode: boolean;
  promises: { [id: string]: DelayedPromise<any>; } = {};
  private promiseCounter: number = 0;

  beginPromise(ns: string|null, func: string|null, arg: any): Promise<any>|null {
    if (!ns || !func) {
      this.log(`BeginPromise: argument null: ${ns}.${func}`);
      return null;
    }

    const promise = new Promise((resolve, reject) => {
      const id = this.generateID();
      const delayedPromise = new DelayedPromise(resolve, reject);
      this.promises[id] = delayedPromise;
      this.log(`BeginPromise: ${ns}.${func} [${id}]`);
       
      try {
        const wind = window as any;
        if (wind.webkit && wind.webkit.messageHandlers) {
          const handler = wind.webkit.messageHandlers[ns];
          if (handler && typeof handler.postMessage === 'function') {
            const call = new WKJCall(id, func, arg);
            handler.postMessage(call)
          }
        }
      } catch(exception) {
        this.log(`BeginPromise: exception: ${JSON.stringify(exception)}`)
      }
       
    });
    return promise;
  }

  endPromise(id: string, data: any, error: any) {
    this.log(`EndPromise: [${id}] data: ${JSON.stringify(data)}, error: ${JSON.stringify(error)}`);
    const delayedPromise = this.promises[id];
    if (!delayedPromise) {
      this.log(`EndPromise: not found`);
      return;
    }
    if (error) {
      delayedPromise.reject(error ? error.default : undefined);
    } else {
      delayedPromise.resolve(data ? data.default : undefined);
    }
    // remove reference
    delete this.promises[id];
  }
  
  private generateID(): string {
    this.promiseCounter++;
    return `p-${this.promiseCounter}`;
  }

  private log(msg: string) {
    if (this.devMode) {
      console.log(msg);
    }
  }
}

const wind = window as any;
if (!wind.__WKJoint) {
  wind.__WKJoint = new WKJointRuntime();
}
