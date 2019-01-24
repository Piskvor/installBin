FROM ubuntu:16.04

RUN apt-get update && apt-get install -y hamster-applet hamster-indicator

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/user && \
    mkdir -p /home/user/.local/share/hamster-applet && \
    echo "user:x:${uid}:${gid}:user,,,:/home/user:/bin/bash" >> /etc/passwd && \
    echo "user:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/user

USER user
ENV HOME /home/user
CMD /bin/bash

