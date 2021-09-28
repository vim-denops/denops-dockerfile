FROM ubuntu
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -y install \
      build-essential \
      cmake \
      curl \
      gettext \
      git \
      libtinfo-dev \
      libtool-bin \
      pkg-config \
      unzip \
 && apt-get clean
# vim
RUN git clone --depth 1 -b v8.2.3081 https://github.com/vim/vim
RUN cd vim \
 && ./configure \
 && make -j$(nproc) install DESTDIR=/work/vim
# neovim
RUN git clone --depth 1 -b release-0.5 https://github.com/neovim/neovim
RUN apt-get -y install curl
RUN apt-get -y install gettext
RUN cd neovim \
 && make -j$(nproc) \
 && make install DESTDIR=/work/neovim

# deno
RUN curl -LO https://github.com/denoland/deno/releases/download/v1.14.0/deno-x86_64-unknown-linux-gnu.zip \
 && unzip deno-x86_64-unknown-linux-gnu.zip \
 && mv deno /usr/bin/deno \
 && rm deno-x86_64-unknown-linux-gnu.zip
