import typescript from 'rollup-plugin-typescript2';

export default {
  input: 'lib/main.ts',
  output: {
    file: 'dist/bundle.js',
    format: 'iife',
  },
	plugins: [
		typescript({ cacheRoot: (require('unique-temp-dir'))() }),
	]
}
