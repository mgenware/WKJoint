import typescript from 'rollup-plugin-typescript2';
import uglify from 'rollup-plugin-uglify';

export default {
  input: 'lib/main.ts',
  output: {
    file: 'dist/js_api_bundle.js',
    format: 'iife',
  },
	plugins: [
    typescript({ cacheRoot: (require('unique-temp-dir'))() }),
    uglify(),
	]
}
