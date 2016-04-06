.PHONY: clean lib test

test: lib
	swift test

clean:
	swift build --clean

lib:
	swift build
