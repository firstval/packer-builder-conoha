VERSION=1.0.0
COMMIT=$(shell git rev-parse --verify HEAD)

PACKAGES=$(shell go list ./... | grep -v /vendor/)
BUILD_FLAGS=-ldflags "-X main.VERSION=$(VERSION) -X main.COMMIT=$(COMMIT)"

.PHONY: all
all: build

.PHONY: build
build: vendor
	go build $(BUILD_FLAGS) .

.PHONY: test
test: vendor
	go test -v $(PACKAGES)
	go vet $(PACKAGES)

.PHONY: clean
clean:
	rm -rf packer-builder-qemu-chroot
	rm -rf dist

dist:
	mkdir -p dist
	
	GOARCH=amd64 GOOS=linux go build $(BUILD_FLAGS) .
	tar -czf dist/packer-builder-conoha_linux_amd64.tar.gz packer-builder-conoha
	rm -rf packer-builder-conoha
	
	GOARCH=amd64 GOOS=darwin go build $(BUILD_FLAGS) .
	tar -czf dist/packer-builder-conoha_darwin_amd64.tar.gz packer-builder-conoha
	rm -rf packer-builder-conoha

vendor:
	glide install -v
