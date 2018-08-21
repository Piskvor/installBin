FROM ubuntu:xenial
RUN apt-get update
RUN apt-get install -y \
        openjdk-8-jdk wget vim.tiny gsettings-desktop-schemas sudo

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/honza && \
    echo "honza:x:${uid}:${gid}:honza,,,:/home/honza:/bin/bash" >> /etc/passwd && \
    echo "honza:x:${uid}:" >> /etc/group && \
    echo "honza ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/honza && \
    chmod 0440 /etc/sudoers.d/honza && \
    chown ${uid}:${gid} -R /home/honza

RUN ln -s /usr/bin/vim.tiny /usr/bin/vim

WORKDIR /root
COPY FiddlerRoot* /root/
RUN keytool -import -noprompt -trustcacerts -alias FiddlerRoot -file /root/FiddlerRoot.cer -keystore "/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts" -storepass changeit && \
        mkdir -p /usr/local/share/ca-certificates/local && \
        openssl x509 -inform DER -in /root/FiddlerRoot.cer -out /usr/local/share/ca-certificates/local/FidlerRoot.crt && \
        update-ca-certificates --fresh && \
        rm -f /root/FiddlerRoot* \
        || true

USER honza
ENV HOME /home/honza
ENV USER honza

WORKDIR $HOME
RUN cd $HOME && \
    mkdir -p .cache && \
    mkdir -p .local && \
    mkdir -p .config/JOSM && \
    ln -s .config/JOSM .josm && \
    mkdir -p bin && \
    cd bin && \
    wget --timestamping https://inst.piskvor.org/josm/update-josm-latest.sh && \
    chmod +x ./update-josm-latest.sh && \
    ./update-josm-latest.sh --all && \
    chmod +x ./josm && \
    chmod +x ./java-proxy-options.sh && \
    ln -s ./josm josm-latest && \
    echo "export PATH=\"\$HOME/bin:\$PATH\"" > $HOME/.bashrc

ENTRYPOINT ["/bin/bash"]
