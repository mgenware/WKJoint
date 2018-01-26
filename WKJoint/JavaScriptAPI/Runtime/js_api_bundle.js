!function(){"use strict";function t(t,e){function n(){this.constructor=t}o(t,e),t.prototype=null===e?Object.create(e):(n.prototype=e.prototype,new n)}var e=function(){return function(t,e){this.resolve=t,this.reject=e}}(),n=function(){return function(t,e,n){this.promiseID=t,this.func=e,this.arg=n}}(),i=function(){function t(){this.promises={},this.promiseCounter=0;var t=window;this.webkit=t.webkit}return t.prototype.beginPromise=function(t,i,o){var r=this;if(!t||!i){var s="BeginPromise: argument null: "+t+"."+i;return this.log(s),Promise.reject(s)}return new Promise(function(s,u){try{if(r.webkit&&r.webkit.messageHandlers){var c=r.webkit.messageHandlers[t];if(c&&"function"==typeof c.postMessage){var a=r.generateID(),f=new e(s,u);r.promises[a]=f,r.log("BeginPromise: "+t+"."+i+" ["+a+"]");var p=new n(a,i,o||{});return void c.postMessage(p)}var h='The namespace "'+t+'" does not exist';return r.log(h),void u(h)}}catch(t){h="BeginPromise: exception: "+JSON.stringify(t);return r.log(h),void u(h)}})},t.prototype.endPromise=function(t,e,n){this.log("EndPromise: ["+t+"] data: "+JSON.stringify(e)+", error: "+JSON.stringify(n));var i=this.promises[t];i?(n?i.reject(n?n.default:void 0):i.resolve(e?e.default:void 0),delete this.promises[t]):this.log("EndPromise: not found")},t.prototype.generateID=function(){return this.promiseCounter++,"p-"+this.promiseCounter},t.prototype.log=function(t){this.devMode&&console.log(t)},t}(),o=Object.setPrototypeOf||{__proto__:[]}instanceof Array&&function(t,e){t.__proto__=e}||function(t,e){for(var n in e)e.hasOwnProperty(n)&&(t[n]=e[n])},r=function(){function t(t,e){this.name=t,this.runtime=e}return t.prototype.invoke=function(t,e){return this.runtime.beginPromise(this.name,t,e)},t}(),s=function(e){function n(t){return e.call(this,"math",t)||this}return t(n,e),n.prototype.add=function(t){return this.invoke("add",t).then(function(t){return t})},n}(r),u=function(e){function n(t){return e.call(this,"alert",t)||this}return t(n,e),n.prototype.sheetAsync=function(){return this.invoke("sheetAsync",null)},n}(r),c=function(){return function(t){this.math=new s(t),this.alert=new u(t)}}();!function(){var t=window;t.__WKJoint||(t.__WKJoint=new i);var e=t.__WKJoint;t.MyJavaScriptAPI||(t.MyJavaScriptAPI=new c(e))}()}();
