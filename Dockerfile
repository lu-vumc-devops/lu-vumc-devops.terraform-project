FROM alpine:3.15.0

ARG USER=dev
ARG HOME_DIR=/home/${USER}

RUN apk add --no-cache openssh git curl bash

RUN addgroup -S dev && adduser -h ${HOME_DIR} -s /bin/bash -D -S dev dev

RUN git clone https://github.com/tfutils/tfenv.git ${HOME_DIR}/.tfenv \
    && mkdir ${HOME_DIR}/.tfenv/versions \
    && ln -s ${HOME_DIR}/.tfenv/bin/* /usr/local/bin \
    && ln -s /usr/local/bin/terraform /usr/local/bin/tf

RUN git clone https://github.com/cunymatthieu/tgenv.git ${HOME_DIR}/.tgenv \
    && mkdir ${HOME_DIR}/.tgenv/versions \
    && ln -s ${HOME_DIR}/.tgenv/bin/* /usr/local/bin \
    && ln -s /usr/local/bin/terragrunt /usr/local/bin/tg

RUN chown -R dev:dev ${HOME_DIR}

USER dev
