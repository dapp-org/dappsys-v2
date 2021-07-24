all: test

build:; dapp build
test:; dapp test
doc-build:; mdbook build doc
doc-serve:; mdbook serve doc
