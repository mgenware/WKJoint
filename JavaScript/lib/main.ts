import Runtime from './runtime';
import API from './api';

(() => {
  // tslint:disable-next-line no-any
  const wind = window as any;

  if (!wind.__WKJoint) {
    wind.__WKJoint = new Runtime();
  }
  const runtime = wind.__WKJoint as Runtime;

  if (!wind.MyJavaScriptAPI) {
    wind.MyJavaScriptAPI = new API(runtime);
  }
})();
