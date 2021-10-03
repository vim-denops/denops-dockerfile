FROM ghcr.io/vim-denops/vim

RUN apt-get update \
 && apt-get install -y --no-install-recommends ripgrep

RUN git clone https://github.com/vim-denops/denops-helloworld.vim \
 && deno cache --unstable */denops/**/*.ts
