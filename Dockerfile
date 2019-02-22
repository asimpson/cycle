FROM alpine:edge

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
    make && \
    mkdir -p /opt/bin && \
    cp cycle /opt/bin

ENTRYPOINT '/opt/bin/cycle'
