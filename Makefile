all: test

build:; dapp build
test:; dapp test -v
build-examples:; DAPP_SRC=doc/src/examples DAPP_REMAPPINGS=$(shell cat doc/src/examples/remappings.txt) dapp build
doc-build:; mdbook build doc
doc-serve:; mdbook serve doc
