"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var main = require("../");
var fs = require("fs");
describe('require this module', function () {
    test('Verify module members', function () {
        expect(typeof main.Namespace).toBe('function');
        expect(typeof main.Runtime).toBe('function');
        expect(typeof main.inject).toBe('function');
    });
    test('Verify type definition files', function () {
        expect(fs.statSync('./dist/main.d.ts').isFile()).toBeTruthy();
    });
});
//# sourceMappingURL=module.test.js.map