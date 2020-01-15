FROM alpine:latest

RUN \
  adduser -h /home/firefox -s /sbin/nologin -u 1000 -D firefox && \
  apk add --no-cache \
    dbus-x11 \
    dumb-init \
    firefox-esr \
    mesa-gl \
    mesa-dri-swrast \
    ttf-freefont


VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
