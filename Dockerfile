FROM alpine:edge

ENV PANDOC_VERSION 2.5
ENV PANDOC_DOWNLOAD_URL https://github.com/jgm/pandoc/archive/$PANDOC_VERSION.tar.gz
ENV PANDOC_ROOT /usr/local/pandoc

RUN apk add --no-cache \
    bash \
    coreutils \
    gmp \
    libffi \
 && apk add --no-cache --virtual build-dependencies \
    --repository "http://nl.alpinelinux.org/alpine/edge/community" \
    ghc \
    cabal \
    curl \
    linux-headers \
    musl-dev \
    zlib-dev \
 && mkdir -p /pandoc-build && cd /pandoc-build \
 && curl -fsSL "$PANDOC_DOWNLOAD_URL" -o pandoc.tar.gz \
 && tar -xzf pandoc.tar.gz && rm -f pandoc.tar.gz \
 && ( cd pandoc-$PANDOC_VERSION && cabal update && cabal install --only-dependencies \
    && cabal configure --prefix=$PANDOC_ROOT \
    && cabal build \
    && cabal copy \
    && cabal clean \
    && cd .. ) \
 && rm -Rf pandoc-$PANDOC_VERSION/ \
 && apk del --purge build-dependencies \
 && rm -Rf /root/.cabal/ /root/.ghc/ \
 && cd / && rm -Rf /pandoc-build

ENV PATH $PATH:$PANDOC_ROOT/bin

RUN apk add --no-cache tree

ENV STYLESHEET /var/style.css
ENV INDEX_HEAD /var/index.head
ENV INDEX_TAIL /var/index.tail

COPY doc-docs/style.css /var/style.css
COPY doc-docs/index.head /var/index.head
COPY doc-docs/index.tail /var/index.tail

ENV OUT_DIR static_files
WORKDIR /data

COPY doc-docs.sh /
CMD ["bash","/doc-docs.sh"]
