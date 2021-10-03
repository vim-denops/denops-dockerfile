# denops-dockerfile

[![Build](https://github.com/vim-denops/denops-dockerfile/actions/workflows/build.yml/badge.svg)](https://github.com/vim-denops/denops-dockerfile/actions/workflows/build.yml)

## Usage

### Minimum

Create a new docker image from [ghcr.io/vim-denops/vim][] or [ghcr.io/vim-denops/neovim][] and clone Vim plugins in working directory like

```Dockerfile
FROM ghcr.io/vim-denops/vim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      ripgrep

ARG VERSION=main
RUN curl -sSL https://github.com/vim-denops/denops-helloworld.vim/archive/${VERSION}.tar.gz \
  | tar xz \
 && deno cache --unstable */denops/**/*.ts
```

Then build and run the image like

```
docker build -f Dockerfile -t vim .
docker run --rm -it vim
```

See [examples/denops-helloworld.vim](./examples/denops-helloworld.vim) for details.

### Advanced

If you need to define `.vimrc`, copy it to `/root/.vimrc` (Vim) or `/root/.config/nvim/init.vim` (Neovim).

For example, [Shougo/ddc.vim](https://github.com/Shougo/ddc.vim) requires `.vimrc` like

```vim
" Load all plugins
packloadall

" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
call ddc#custom#patch_global('sources', ['around'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

" Use ddc.
call ddc#enable()
```

Copy above `.vimrc` with `COPY` command like

```Dockerfile
FROM ghcr.io/vim-denops/vim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git

RUN git clone https://github.com/Shougo/ddc.vim \
 && git clone https://github.com/Shougo/ddc-around \
 && git clone https://github.com/Shougo/ddc-matcher_head \
 && git clone https://github.com/Shougo/ddc-sorter_rank \
 && deno cache --unstable */denops/**/*.ts

COPY vimrc /root/.vimrc
```

Then build and run the image like

```
docker build -f Dockerfile -t vim .
docker run --rm -it vim
```

See [examples/ddc.vim](./examples/ddc.vim) for details.

[ghcr.io/vim-denops/vim]: https://github.com/vim-denops/denops-dockerfile/pkgs/container/vim
[ghcr.io/vim-denops/neovim]: https://github.com/vim-denops/denops-dockerfile/pkgs/container/neovim

## Development

Build [ghcr.io/vim-denops/vim][] and [ghcr.io/vim-denops/neovim][] with

```
make build
```

The push it with

```
make push
```

## License

The code follows MIT license written in [LICENSE](./LICENSE). Contributors need
to agree that any modifications sent in this repository follow the license.
