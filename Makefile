all: build

build:
	cd pkg/ && go install -v ./...
deps-update:
	glide cc && glide update --strip-vendor
	hack/dep-prune.sh

test:
	cd pkg/ && ginkgo -v ./...

.PHONY: build deps-update test
