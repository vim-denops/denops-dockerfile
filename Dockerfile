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
COPY --from=0 --chown=denops:denops /root/denops.vim /home/denops/.vim/pack/denops/start/denops.vim
