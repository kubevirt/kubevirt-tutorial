export GOFLAGS=-mod=vendor
export GO111MODULE=on

all: build

build:
	cd pkg/ && go fmt ./... && go install -v ./...
deps-update:
	go mod tidy
	go mod vendor

test:
	cd pkg/ && go test -v ./...

.PHONY: build deps-update test
