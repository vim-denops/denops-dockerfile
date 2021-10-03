FROM ghcr.io/vim-denops/vim

RUN git clone https://github.com/Shougo/ddc.vim \
 && git clone https://github.com/Shougo/ddc-around \
 && git clone https://github.com/Shougo/ddc-matcher_head \
 && git clone https://github.com/Shougo/ddc-sorter_rank \
 && deno cache --unstable */denops/**/*.ts

COPY vimrc /root/.vimrc