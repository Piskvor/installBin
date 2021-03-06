FROM alpine
MAINTAINER Justin J. Novack <jnovack@gmail.com>

ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="MIT" \
      org.label-schema.name="jnovack/docker-autossh" \
      org.label-schema.url="https://hub.docker.com/r/jnovack/docker-autossh/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-type="Git" \
      org.label-schema.vcs-url="https://github.com/jnovack/docker-autossh"


ENV \
    TERM=xterm \
    AUTOSSH_LOGFILE=/dev/stdout \
    AUTOSSH_GATETIME=30         \
    AUTOSSH_POLL=10             \
    AUTOSSH_FIRST_POLL=30       \
    AUTOSSH_LOGLEVEL=2

RUN apk update && \
    echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    apk add --update autossh moreutils@testing && \
    rm -rf /var/lib/apt/lists/*

ADD /entrypoint.sh /autossh-entrypoint.sh
RUN touch /autossh.pid && \
    chmod 755 /autossh* && \
    adduser -u 1000 appuser -D && \
    chown appuser /autossh*
USER appuser

ENTRYPOINT ["/autossh-entrypoint.sh"]
