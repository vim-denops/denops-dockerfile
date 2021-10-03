# syntax=docker/dockerfile:1.3
#------------------------------------------------------------------------------------------------------------
FROM debian:bullseye-backports as vim
ENV DEBIAN_FRONTEND=noninteractive

# Install requirements
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    --mount=type=cache,target=/var/lib/apt,sharing=private \
    apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      build-essential \
      gettext \
      libtinfo-dev

ARG VIM_VERSION=v8.2.3081
RUN mkdir -p /working \
 && curl -sSL https://github.com/vim/vim/archive/${VIM_VERSION}.tar.gz \
  | tar xz -C /working --strip-components=1

WORKDIR /working
RUN ./configure --prefix=/opt/vim --with-features=huge --enable-fail-if-missing
RUN make -j$(nproc)
RUN make install


#------------------------------------------------------------------------------------------------------------
FROM debian:bullseye-backports as deno
ENV DEBIAN_FRONTEND=noninteractive

# Install requirements
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    --mount=type=cache,target=/var/lib/apt,sharing=private \
    apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      unzip \
      git

ARG DENO_VERSION=v1.14.0
WORKDIR /working
RUN curl -sSL -O https://github.com/denoland/deno/releases/download/${DENO_VERSION}/deno-x86_64-unknown-linux-gnu.zip \
 && unzip deno-x86_64-unknown-linux-gnu.zip
RUN mkdir -p /opt/deno/bin \
 && mv deno /opt/deno/bin/deno


#------------------------------------------------------------------------------------------------------------
FROM debian:bullseye-slim as runtime

LABEL org.opencontainers.image.url https://github.com/orgs/vim-denops/packages/container/package/vim
LABEL org.opencontainers.image.source https://github.com/vim-denops/denops-dockerfile

# Prefer to use Debian Backports
# https://backports.debian.org/
RUN echo 'deb http://deb.debian.org/debian bullseye-backports main' > /etc/apt/sources.list.d/backports.list

# Install requirements
RUN --mount=type=cache,target=/var/cache/apt,sharing=private \
    --mount=type=cache,target=/var/lib/apt,sharing=private \
    apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates \
      git

# Runtime environment
ENV LC_ALL=C.UTF-8 \
    PATH=/opt/vim/usr/local/bin:/opt/deno/bin:${PATH}

COPY --from=vim /opt/vim /opt/vim
COPY --from=deno /opt/deno /opt/deno

# Install denops.vim
WORKDIR /root/.vim/pack/denops/start
ARG DENOPS_VERSION=main
RUN mkdir -p denops.vim \
 && cd denops.vim \
 && git init \
 && git remote add origin https://github.com/vim-denops/denops.vim.git \
 && git fetch origin ${DENOPS_VERSION} \
 && git reset --hard FETCH_HEAD
RUN deno cache --unstable */denops/**/*.ts

ENTRYPOINT ["/opt/vim/bin/vim"]
