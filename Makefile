DENOPS_VERSION := main

.DEFAULT_GOAL := help

help:
	@cat $(MAKEFILE_LIST) | \
	    perl -ne 'print if /^\w+.*##/;' | \
	    perl -pe 's/(.*):.*##\s*/sprintf("%-20s",$$1)/eg;'

build: build-vim build-neovim	## Build

build-vim: FORCE	## Build (Vim)
	docker buildx build \
		--load \
	    	--cache-from=ghcr.io/vim-denops/vim/cache \
	    	--cache-from=ghcr.io/vim-denops/vim \
	    	--cache-to=type=registry,ref=ghcr.io/vim-denops/vim/cache,mode=max \
		--build-arg DENOPS_VERSION=${DENOPS_VERSION} \
		-t ghcr.io/vim-denops/vim:${DENOPS_VERSION} \
		-t ghcr.io/vim-denops/vim \
		-f Dockerfile.vim \
		.

build-neovim: FORCE	## Build (Neovim)
	docker buildx build \
		--load \
	    	--cache-from=ghcr.io/vim-denops/neovim/cache \
	    	--cache-from=ghcr.io/vim-denops/neovim \
	    	--cache-to=type=registry,ref=ghcr.io/vim-denops/neovim/cache,mode=max \
		--build-arg DENOPS_VERSION=${DENOPS_VERSION} \
		-t ghcr.io/vim-denops/neovim:${DENOPS_VERSION} \
		-t ghcr.io/vim-denops/neovim \
		-f Dockerfile.neovim \
		.

push: push-vim push-neovim	## Push

push-vim: FORCE	## Push (Vim)
	docker push ghcr.io/vim-denops/vim:${DENOPS_VERSION}
	docker push ghcr.io/vim-denops/vim

push-neovim: FORCE	## Push (Neovim)
	docker push ghcr.io/vim-denops/neovim:${DENOPS_VERSION}
	docker push ghcr.io/vim-denops/neovim

FORCE:
