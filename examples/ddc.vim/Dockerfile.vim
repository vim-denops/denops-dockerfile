FROM ghcr.io/vim-denops/vim

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git

RUN git clone https://github.com/Shougo/ddc.vim \
 && git clone https://github.com/Shougo/ddc-around \
 && git clone https://github.com/Shougo/ddc-matcher_head \
 && git clone https://github.com/Shougo/ddc-sorter_rank \
 && deno cache --unstable --no-check=remote */denops/**/*.ts

COPY vimrc /root/.vimrc
