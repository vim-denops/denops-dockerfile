FROM ghcr.io/vim-denops/vim

RUN git clone https://github.com/vim-denops/denops-helloworld.vim \
 && deno cache --unstable */denops/**/*.ts
