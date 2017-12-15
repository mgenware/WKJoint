import Runtime from './runtime';

export default class Namespace {
  constructor(public name: string, public runtime: Runtime) { }

  invoke(func: string, arg: object): Promise<any> {
    return this.runtime.beginPromise(this.name, func, arg);
  }
}
