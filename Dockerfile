FROM archlinux:latest


RUN groupadd firefox && \
  useradd --create-home --gid firefox firefox && \
  chown --recursive firefox:firefox /home/firefox/


RUN pacman -Sy reflector --noconfirm
RUN reflector --score 10 --save /etc/pacman.d/mirrorlist
RUN yes | pacman -Syyu

RUN set -euxo pipefail && \
  VERSION=`curl -s https://github.com/Yelp/dumb-init/releases/latest | sed 's/.*tag\/v\([0-9.]*\).*/\1/'` && \
	curl -sSL https://github.com/Yelp/dumb-init/releases/download/v${VERSION}/dumb-init_${VERSION}_amd64 > /usr/local/bin/dumb-init && \
	chmod +x /usr/local/bin/dumb-init

RUN pacman -S \
    socat \
    firefox \
    --noconfirm

RUN yes | pacman -Scc


VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
