DENOPS_VERSION := main
DOCKER_TAG := latest
DOCKER_REGISTRY := ghcr.io/vim-denops

.DEFAULT_GOAL := help

help:
	@cat $(MAKEFILE_LIST) | \
	    perl -ne 'print if /^\w+.*##/;' | \
	    perl -pe 's/(.*):.*##\s*/sprintf("%-20s",$$1)/eg;'

build: build-vim build-neovim	## Build

build-vim: FORCE	## Build (Vim)
	docker buildx build ${BUILD_ARGS} \
		--load \
		--cache-from=${DOCKER_REGISTRY}/vim/cache \
		--cache-from=${DOCKER_REGISTRY}/vim \
		--cache-to=type=registry,ref=${DOCKER_REGISTRY}/vim/cache,mode=max \
		--build-arg DENOPS_VERSION=${DENOPS_VERSION} \
		--platform linux/amd64,linux/arm64 \
		-t ${DOCKER_REGISTRY}/vim:${DOCKER_TAG} \
		-f dockerfiles/vim \
		.

build-neovim: FORCE	## Build (Neovim)
	docker buildx build ${BUILD_ARGS} \
		--load \
		--cache-from=${DOCKER_REGISTRY}/neovim/cache \
		--cache-from=${DOCKER_REGISTRY}/neovim \
		--cache-to=type=registry,ref=${DOCKER_REGISTRY}/neovim/cache,mode=max \
		--build-arg DENOPS_VERSION=${DENOPS_VERSION} \
		--platform linux/amd64,linux/arm64 \
		-t ${DOCKER_REGISTRY}/neovim:${DOCKER_TAG} \
		-f dockerfiles/neovim \
		.

push: push-vim push-neovim	## Push

push-vim: FORCE	## Push (Vim)
	docker push ${DOCKER_REGISTRY}/vim:${DOCKER_TAG}

push-neovim: FORCE	## Push (Neovim)
	docker push ${DOCKER_REGISTRY}/neovim:${DOCKER_TAG}

FORCE:
