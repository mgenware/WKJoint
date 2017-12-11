 /*************************************************************************
 *
 * WKJoint Runtime.ts
 * github.com/mgenware/WKJoint
 * @ 2017 Mgen
 *
 *
 * Inspired by http://igomobile.de/2017/03/06/wkwebview-return-a-value-from-native-code-to-javascript/
 */

 // Any data returned from client will conform to IClientData interface
interface IClientData {
  default: object;
}

 // Pending promise object tracked in context
class DelayedPromise<T> {
  constructor(
    public resolve: (value?: T | PromiseLike<T>) => void,
    public reject: (reason?: object) => void,
  ) { }
}

class WKJCall {
  constructor(public promiseID: string, public func: string, public arg: object) {}
}

class WKJointRuntime {
  devMode: boolean;
  promises: { [id: string]: DelayedPromise<object>; } = {};
  private promiseCounter: number = 0;

  beginPromise(ns: string|null, func: string|null, arg: object): Promise<object>|null {
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
        // tslint:disable-next-line no-any
        const wind = window as any;
        if (wind.webkit && wind.webkit.messageHandlers) {
          const handler = wind.webkit.messageHandlers[ns];
          if (handler && typeof handler.postMessage === 'function') {
            const call = new WKJCall(id, func, arg);
            handler.postMessage(call);
          }
        }
      } catch (err) {
        this.log(`BeginPromise: exception: ${JSON.stringify(err)}`);
      }
    });
    return promise;
  }

  endPromise(id: string, data: IClientData|undefined, error: IClientData|undefined) {
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
      // tslint:disable-next-line no-console
      console.log(msg);
    }
  }
}

(() => {
  // tslint:disable-next-line no-any
  const wind = window as any;
  if (!wind.__WKJoint) {
    wind.__WKJoint = new WKJointRuntime();
  }
})();
