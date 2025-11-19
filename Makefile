.PHONY: setup test

setup:
	sh ./setup.sh

test:
	sh ./run_tests.sh

all: setup test
