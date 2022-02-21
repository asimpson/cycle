FROM alpine:edge as builder

LABEL maintainer="mike@mikeyockey.com"

RUN mkdir /src

WORKDIR /src

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk add sbcl curl build-base && \
    curl -L -o quicklisp.lisp "https://beta.quicklisp.org/quicklisp.lisp" && \
    sbcl --load quicklisp.lisp \
         --eval "(quicklisp-quickstart:install :path \"/opt/quicklisp\")" \
         --eval "(quit)" && \
    sbcl --load /opt/quicklisp/setup.lisp \
         --eval "(ql::without-prompting (ql:add-to-init-file))" \
         --eval "(quit)" && \
    curl -L -o cycle-master.zip "https://github.com/asimpson/cycle/archive/master.zip" && \
    unzip cycle-master.zip && \
    cd cycle-master && \
    make

RUN cd /src && curl -L -o chroma.tar.gz "https://github.com/alecthomas/chroma/releases/download/v0.10.0/chroma-0.10.0-linux-amd64.tar.gz"

RUN tar -xvf chroma.tar.gz

FROM alpine:edge

WORKDIR /opt/bin

COPY --from=builder /src/cycle-master/cycle .
COPY --from=builder /src/chroma .

RUN mkdir /site

WORKDIR /site

ENV PATH="/opt/bin:${PATH}"

CMD ["cycle"]
