FROM ubuntu:bionic

RUN apt-get update && \
    apt-get --no-install-recommends --yes install firefox=61.\* dumb-init socat && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

EXPOSE 2828

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
