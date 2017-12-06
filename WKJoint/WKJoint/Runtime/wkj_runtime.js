"use strict";
var DelayedPromise = (function () {
    function DelayedPromise() {
    }
    return DelayedPromise;
}());
var WKJCall = (function () {
    function WKJCall(promiseID, func, arg) {
        this.promiseID = promiseID;
        this.func = func;
        this.arg = arg;
    }
    return WKJCall;
}());
var WKJointRuntime = (function () {
    function WKJointRuntime() {
        this.promises = {};
    }
    WKJointRuntime.prototype.beginPromise = function (ns, func, arg) {
        var _this = this;
        if (!ns || !func) {
            return null;
        }
        var promise = new Promise(function (resolve, reject) {
            var id = _this.uuidv4();
            var delayedPromise = new DelayedPromise();
            delayedPromise.resolve = resolve;
            delayedPromise.reject = reject;
            _this.promises[id] = delayedPromise;
            try {
                var wind_1 = window;
                if (wind_1.webkit && wind_1.webkit.messageHandlers) {
                    var handler = wind_1.webkit.messageHandlers[ns];
                    if (handler && typeof handler.postMessage === 'function') {
                        var call = new WKJCall(id, func, arg);
                        handler.postMessage(call);
                    }
                }
            }
            catch (exception) {
                alert(exception);
            }
        });
        return promise;
    };
    WKJointRuntime.prototype.endPromise = function (id, data, error) {
        var delayedPromise = this.promises[id];
        if (!delayedPromise) {
            return;
        }
        if (error) {
            delayedPromise.reject(error);
        }
        else {
            delayedPromise.resolve(data ? data.default : undefined);
        }
        delete this.promises[id];
    };
    WKJointRuntime.prototype.uuidv4 = function () {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    };
    return WKJointRuntime;
}());
var wind = window;
if (!wind.__WKJoint) {
    wind.__WKJoint = new WKJointRuntime();
}
