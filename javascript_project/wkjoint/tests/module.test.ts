import * as main from '../';
import * as fs from 'fs';

describe('require this module', () => {
  test('Verify module members', () => {
    expect(typeof main.Namespace).toBe('function');
    expect(typeof main.Runtime).toBe('function');
    expect(typeof main.inject).toBe('function');
  });

  test('Verify type definition files', () => {
    expect(fs.statSync('./dist/main.d.ts').isFile()).toBeTruthy();
  });
});
