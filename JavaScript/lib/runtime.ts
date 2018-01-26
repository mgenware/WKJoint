 /*************************************************************************
 *
 * WKJoint Runtime.ts
 * https://github.com/mgenware/WKJoint
 * @ 2018 Mgen
 *
 */

 // Any data returned from client must conform to the IClientData interface
export interface IClientData {
  default: object;
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

export default class WKJointRuntime {
  webkit: any|null;
  devMode: boolean;
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
      const id = this.generateID();
      const delayedPromise = new DelayedPromise(resolve, reject);
      this.promises[id] = delayedPromise;
      this.log(`BeginPromise: ${ns}.${func} [${id}]`);

      try {
        if (this.webkit && this.webkit.messageHandlers) {
          const handler = this.webkit.messageHandlers[ns];
          if (handler && typeof handler.postMessage === 'function') {
            const call = new WKJCall(id, func, arg || {});
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
