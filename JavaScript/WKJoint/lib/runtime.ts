/*************************************************************************
 *
 * WKJoint Runtime.ts
 * https://github.com/mgenware/WKJoint
 * @ 2018 Mgen
 *
 */

// Any data returned from client must conform to the IClientData interface
export interface IClientData {
  value: object;
}

// Pending promise object tracked in context
export class DelayedPromise<T> {
  constructor(
    public resolve: (value?: T | PromiseLike<T>) => void,
    public reject: (reason?: object) => void,
  ) { }
}

class WKJCall {
  constructor(public promiseID: string, public func: string, public arg: object) {}
}

export class Runtime {
  webkit: any|null;
  devMode: boolean = false;
  promises: { [id: string]: DelayedPromise<object>; } = {};
  private promiseCounter: number = 0;

  constructor() {
    const wind = window as any;
    this.webkit = wind.webkit;
  }

  beginPromise(ns: string|null, func: string|null, arg: object|null): Promise<any> {
    if (!ns || !func) {
      const reason = `BeginPromise: argument null: ${ns}.${func}`;
      this.log(reason);
      return Promise.reject(reason);
    }

    const promise = new Promise((resolve, reject) => {
      try {
        if (this.webkit && this.webkit.messageHandlers) {
          const handler = this.webkit.messageHandlers[ns];
          if (handler && typeof handler.postMessage === 'function') {
            // generate an unique ID
            const id = this.generateID();
            // create a delayed promise
            const delayedPromise = new DelayedPromise(resolve, reject);
            // add it to the pending array
            this.promises[id] = delayedPromise;
            // logging
            this.log(`BeginPromise: ${ns}.${func} [${id}]`);

            // start native call
            const call = new WKJCall(id, func, arg || {});
            handler.postMessage(call);

            // this return statement ensures we won't fall through
            return;
          }

          // rejected by namespace not found
          const errMsg = `The namespace "${ns}" does not exist`;
          this.log(errMsg);
          reject(errMsg);
          return;
        }
      } catch (err) {
        // rejected by exception
        const errMsg = `BeginPromise: exception: ${JSON.stringify(err)}`;
        this.log(errMsg);
        reject(errMsg);
        return;
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
      delayedPromise.reject(error ? error.value : undefined);
    } else {
      delayedPromise.resolve(data ? data.value : undefined);
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
