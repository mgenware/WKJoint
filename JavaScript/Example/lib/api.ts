import { Namespace, Runtime } from 'wkjoint';

export interface IAddArgument {
  x: number;
  y: number;
}

export class MathNamespace extends Namespace {
  constructor(runtime: Runtime) {
    super('math', runtime);
  }

  add(arg: IAddArgument): Promise<number> {
    return this.invoke('add', arg).then((result) => {
      return result as number;
    });
  }
}

export class AlertNamespace extends Namespace {
  constructor(runtime: Runtime) {
    super('alert', runtime);
  }

  sheetAsync(): Promise<string> {
    return this.invoke('sheetAsync', null);
  }
}

export default class MyAPI {
  math: MathNamespace;
  alert: AlertNamespace;

  constructor(runtime: Runtime) {
    this.math = new MathNamespace(runtime);
    this.alert = new AlertNamespace(runtime);
  }
}
