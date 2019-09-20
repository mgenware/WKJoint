import * as main from '../';
import * as fs from 'fs';
import * as assert from 'assert';

describe('require this module', () => {
  it('Verify module members', () => {
    assert.equal(typeof main.Namespace, 'function');
    assert.equal(typeof main.Runtime, 'function');
    assert.equal(typeof main.inject, 'function');
  });

  it('Verify type definition files', () => {
    assert.equal(fs.statSync('./dist/main.d.ts').isFile(), true);
  });
});
