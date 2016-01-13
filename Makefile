BUILD_DIR=./.build/debug

.PHONY: clean lib test

test: lib
	$(BUILD_DIR)/spectre-build

clean:
	swift build --clean

lib:
	swift build
