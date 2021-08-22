all: test

build:; dapp build
test:; dapp test -v --smttimeout 600000 --fuzz-runs 10000 --depth 100
build-examples:; DAPP_SRC=doc/src/examples DAPP_REMAPPINGS=$(shell cat doc/src/examples/remappings.txt) dapp build
doc-build:; mdbook build doc
doc-serve:; mdbook serve doc
