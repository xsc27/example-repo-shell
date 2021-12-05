.PHONY: lint build build-container test test-container docs all help
.SILENT:
.NOTPARALLEL:
.POSIX:
.ONESHELL:

.DEFAULT_GOAL := help
.SHELLFLAGS := -euc
SHELL := sh
OS = $(shell uname -s)

CONTAINER?=local/make-example
CONTAINER_TAG?=$(shell git rev-parse --short HEAD)

lint:  ## Lint code
	echo 'Running linter...'
	pre-commit run --all-files --show-diff-on-failure --color=always
	if [ -n "$(shell git ls-files --others --exclude-standard | grep '\.sh$$')" ]; then \
	  shellcheck -o all $(shell git ls-files --others --exclude-standard | grep '\.sh$$') ;\
	fi

build:  ## Build artifact
	echo 'Compiling artifact...'
	mkdir -p dist
	cp -fv src/prog.sh dist/
	chmod +x dist/prog.sh

build-container: build  ## Build container
	echo 'Building container...'
	docker image build --tag ${CONTAINER}:${CONTAINER_TAG} .

test: build  ## Run unit tests
	mkdir -p .tests
	echo 'Running tests...'
	docker container run --pull always --rm -tv "${PWD}:/code" bats/bats:latest \
	  --recursive --output .tests --report-formatter junit tests

test-container: build-container  ## Validate container
	mkdir -p .tests
	if ! ls ./goss-linux-amd64 ; then \
	  LATEST_URL='$(shell curl -sLo /dev/null https://github.com/aelsabbahy/goss/releases/latest -w '%{url_effective}')' ;\
	  GOSS_VER="$${GOSS_VER:-$${LATEST_URL##*/}}" ;\
	  echo Downloading goss $${GOSS_VER} ;\
	  curl -sLO https://github.com/aelsabbahy/goss/releases/download/$${GOSS_VER}/goss-linux-amd64 ;\
	  chmod +x goss-linux-amd64 ;\
	fi

	echo 'Running tests...'
	docker container run --rm -t \
	  -v "${PWD}/goss-linux-amd64:/usr/local/bin/goss" \
	  -v "${PWD}/tests:/opt/goss" \
	  --entrypoint goss \
	  ${CONTAINER}:${CONTAINER_TAG} \
	    --gossfile /opt/goss/goss.yaml v $(shell [ -n '$(CI)' ] && printf -- '--format junit | tee .tests/goss.xml')
	docker image rm --no-prune ${CONTAINER}:${CONTAINER_TAG}

docs:  ## Generate documentation
	type mkdocs > /dev/null
	echo 'Building docs...'
	docker container run --pull always --rm -v "${PWD}:/docs" -p '127.0.0.1:8000:8000/tcp' squidfunk/mkdocs-material $${CMD:-build}

all: lint test test-container docs  ## Run all steps

help:  ## Display this help msg
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
