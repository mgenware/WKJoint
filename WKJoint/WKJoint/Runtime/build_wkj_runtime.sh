command -v tsc >/dev/null 2>&1 || { echo >&2 "Error: TypeScript compiler is not installed."; exit 1; }
command -v uglifyjs >/dev/null 2>&1 || { echo >&2 "Error: UglifyJS is not installed."; exit 1; }
echo 'Compiling...'
tsc && uglifyjs wkj_runtime.js -cmo wkj_runtime.js
if [ $? -eq 0 ]; then
    echo 'Task succeeded.'
else
    echo 'Task failed.'
fi