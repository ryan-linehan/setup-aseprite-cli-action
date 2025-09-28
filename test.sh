set -e

rm -rf ./test/actual

# Debug: Check if binary exists and what it needs
echo "=== Debugging aseprite binary ==="
ls -la build/bin/aseprite
file build/bin/aseprite
echo "=== Checking library dependencies ==="
ldd build/bin/aseprite
echo "=== Running aseprite commands ==="

aseprite --batch --help
aseprite --batch --version
aseprite --batch --list-tags --trim ./test/example.ase --data ./test/actual/example.json --save-as ./test/actual/example.png

cmp <(ls ./test/actual) <(echo "example.json
example1.png
example2.png
example3.png
example4.png
example5.png
example6.png
example7.png
example8.png
example9.png")

npm ci

cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example1.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example2.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example3.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example4.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example5.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example6.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example7.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example8.png) <(echo "48x32")
cmp <(npx ts-node ./test/convert-image.ts ./test/actual/example9.png) <(echo "48x32")

cmp ./test/expected/example1.rgba ./test/actual/example1.rgba
cmp ./test/expected/example2.rgba ./test/actual/example2.rgba
cmp ./test/expected/example3.rgba ./test/actual/example3.rgba
cmp ./test/expected/example4.rgba ./test/actual/example4.rgba
cmp ./test/expected/example5.rgba ./test/actual/example5.rgba
cmp ./test/expected/example6.rgba ./test/actual/example6.rgba
cmp ./test/expected/example7.rgba ./test/actual/example7.rgba
cmp ./test/expected/example8.rgba ./test/actual/example8.rgba
cmp ./test/expected/example9.rgba ./test/actual/example9.rgba

cmp <(jq -cS . ./test/expected/example.json) <(jq -cS . ./test/actual/example.json)
