import typescript from 'rollup-plugin-typescript2';
import { terser } from "rollup-plugin-terser";
import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';

export default {
  input: 'lib/main.ts',
  output: {
    file: 'dist/js_api_bundle.js',
    format: 'iife',
  },
	plugins: [
    resolve({
      module: true,
      browser: true,
    }),
    commonjs(),
    typescript({ cacheRoot: (require('unique-temp-dir'))() }),
    terser(),
	],
}
