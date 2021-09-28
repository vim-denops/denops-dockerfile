# syntax=docker/dockerfile:1.3-labs
FROM denops-build
RUN git clone https://github.com/vim-denops/denops.vim

FROM ubuntu
COPY --from=0 /work/vim/ /
COPY --from=0 /work/neovim/ /
COPY --from=0 /usr/bin/deno /usr/bin/deno
RUN useradd -m denops \
 && echo root:root | chpasswd \
 && echo denops:denops | chpasswd
USER denops
COPY <<END /home/denops/.vim/vimrc
syntax enable
filetype plugin indent on
END
COPY <<END /home/denops/.config/nvim/init.vim
set rtp^=~/.vim
set packpath^=~/.vim
source ~/.vim/vimrc
END
COPY --from=0 --chown=denops:denops /root/denops.vim /home/denops/.vim/pack/denops/start/denops.vim
