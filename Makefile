BACKEND?=docker
CONCURRENCY?=1
CI_ARGS?=
PACKAGES?=

# Abs path only. It gets copied in chroot in pre-seed stages
export BHOJPUR_ISO_MANAGER?=/usr/bin/isomgr
export ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
DESTINATION?=$(ROOT_DIR)/build
COMPRESSION?=gzip
CLEAN?=false
export TREE?=$(ROOT_DIR)/packages
BUILD_ARGS?=-d --image-repository bhojpuros/rindex-amd64-cache
SUDO?=
VALIDATE_OPTIONS?=-s

.PHONY: all
all: deps build

.PHONY: deps
deps:
	@echo "Installing Bhojpur ISO"
	go get -u github.com/bhojpur/iso

.PHONY: clean
clean:
	$(SUDO) rm -rf build/ *.tar *.metadata.yaml

.PHONY: build
build: clean
	mkdir -p $(ROOT_DIR)/build
	$(SUDO) $(BHOJPUR_ISO_MANAGER) build $(BUILD_ARGS) --tree=$(TREE)  $(PACKAGES) --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: build-all
build-all: clean
	mkdir -p $(ROOT_DIR)/build
	$(SUDO) $(BHOJPUR_ISO_MANAGER) build $(BUILD_ARGS)  --tree=$(TREE) --full --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: rebuild
rebuild:
	$(SUDO) $(BHOJPUR_ISO_MANAGER) build $(BUILD_ARGS) --tree=$(TREE) $(PACKAGES) --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: rebuild-all
rebuild-all:
	$(SUDO) $(BHOJPUR_ISO_MANAGER) build $(BUILD_ARGS) --tree=$(TREE) --full --destination $(ROOT_DIR)/build --backend $(BACKEND) --concurrency $(CONCURRENCY) --compression $(COMPRESSION)

.PHONY: create-repo
create-repo:
	$(SUDO) $(BHOJPUR_ISO_MANAGER) create-repo --tree "$(TREE)" \
    --output $(DESTINATION) \
    --packages $(DESTINATION) \
    --name "mocaccino-repository-index" \
    --descr "Mocaccino repository index" \
    --urls "https://raw.githubusercontent.com/mocaccinoOS/repository-index/gh-pages" \
    --tree-compression gzip \
    --tree-filename tree.tar \
    --meta-compression gzip \
    --type http

.PHONY: serve-repo
serve-repo:
	BHOJPUR_ISO_NOLOCK=true $(BHOJPUR_ISO_MANAGER) serve-repo --port 8000 --dir $(ROOT_DIR)/build

validate:
	$(BHOJPUR_ISO_MANAGER) tree validate --tree $(TREE) $(VALIDATE_OPTIONS)

.PHONY: auto-bump
auto-bump:
	TREE_DIR=$(TREE) $(BHOJPUR_ISO_MANAGER) autobump-github

autobump: auto-bump
