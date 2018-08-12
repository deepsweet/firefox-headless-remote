FROM ubuntu:bionic

RUN apt-get update && \
    apt-get --no-install-recommends --yes install firefox=61.\* dumb-init socat && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

COPY entrypoint.sh /home/firefox

USER firefox

EXPOSE 2828

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
