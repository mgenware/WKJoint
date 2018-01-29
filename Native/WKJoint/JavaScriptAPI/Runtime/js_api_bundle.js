!function(){"use strict";var e=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(e,t){e.__proto__=t}||function(e,t){for(var n in t)t.hasOwnProperty(n)&&(e[n]=t[n])};function t(t,n){function r(){this.constructor=t}e(t,n),t.prototype=null===n?Object.create(n):(r.prototype=n.prototype,new r)}function n(e){return e&&e.__esModule&&Object.prototype.hasOwnProperty.call(e,"default")?e.default:e}function r(e,t){return e(t={exports:{}},t.exports),t.exports}var o=r(function(e,t){Object.defineProperty(t,"__esModule",{value:!0});var n=function(){return function(e,t){this.resolve=e,this.reject=t}}();t.DelayedPromise=n;var r=function(){return function(e,t,n){this.promiseID=e,this.func=t,this.arg=n}}(),o=function(){function e(){this.promises={},this.promiseCounter=0;var e=window;this.webkit=e.webkit}return e.prototype.beginPromise=function(e,t,o){var i=this;if(!e||!t){var s="BeginPromise: argument null: "+e+"."+t;return this.log(s),Promise.reject(s)}return new Promise(function(s,u){try{if(i.webkit&&i.webkit.messageHandlers){var a=i.webkit.messageHandlers[e];if(a&&"function"==typeof a.postMessage){var c=i.generateID(),f=new n(s,u);i.promises[c]=f,i.log("BeginPromise: "+e+"."+t+" ["+c+"]");var p=new r(c,t,o||{});return void a.postMessage(p)}var l='The namespace "'+e+'" does not exist';return i.log(l),void u(l)}}catch(e){l="BeginPromise: exception: "+JSON.stringify(e);return i.log(l),void u(l)}})},e.prototype.endPromise=function(e,t,n){this.log("EndPromise: ["+e+"] data: "+JSON.stringify(t)+", error: "+JSON.stringify(n));var r=this.promises[e];r?(n?r.reject(n?n.default:void 0):r.resolve(t?t.default:void 0),delete this.promises[e]):this.log("EndPromise: not found")},e.prototype.generateID=function(){return this.promiseCounter++,"p-"+this.promiseCounter},e.prototype.log=function(e){this.devMode&&console.log(e)},e}();t.Runtime=o});n(o);o.DelayedPromise,o.Runtime;var i=r(function(e,t){Object.defineProperty(t,"__esModule",{value:!0});var n=function(){function e(e,t){this.name=e,this.runtime=t}return e.prototype.invoke=function(e,t){return this.runtime.beginPromise(this.name,e,t)},e}();t.default=n});n(i);var s=r(function(e,t){Object.defineProperty(t,"__esModule",{value:!0}),t.default=function(e,t){var n=window;return!n[e]&&(n[e]=t,!0)}});n(s);var u=r(function(e,t){Object.defineProperty(t,"__esModule",{value:!0}),t.Runtime=o.Runtime,t.Namespace=i.default,t.inject=s.default});n(u);var a=u.Runtime,c=u.Namespace,f=u.inject,p=function(e){function n(t){return e.call(this,"math",t)||this}return t(n,e),n.prototype.add=function(e){return this.invoke("add",e).then(function(e){return e})},n}(c),l=function(e){function n(t){return e.call(this,"alert",t)||this}return t(n,e),n.prototype.sheetAsync=function(){return this.invoke("sheetAsync",null)},n}(c),d=function(){return function(e){this.math=new p(e),this.alert=new l(e)}}();!function(){var e=new a,t=new d(e);f("__WKJoint",e),f("MyJavaScriptAPI",t)}()}();
