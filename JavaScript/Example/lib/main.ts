import API from './api';
import { inject, Runtime } from 'wkjoint';

(() => {
  const runtime = new Runtime();
  const api = new API(runtime);
  inject('__WKJoint', runtime);
  inject('MyJavaScriptAPI', api);
})();
