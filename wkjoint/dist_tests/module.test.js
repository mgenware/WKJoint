"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var main = require("../");
var fs = require("fs");
var assert = require("assert");
describe('require this module', function () {
    it('Verify module members', function () {
        assert.equal(typeof main.Namespace, 'function');
        assert.equal(typeof main.Runtime, 'function');
        assert.equal(typeof main.inject, 'function');
    });
    it('Verify type definition files', function () {
        assert.equal(fs.statSync('./dist/main.d.ts').isFile(), true);
    });
});
//# sourceMappingURL=module.test.js.map