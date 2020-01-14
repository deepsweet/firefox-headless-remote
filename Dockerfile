FROM ubuntu:eoan

RUN apt-get update
RUN apt-get install software-properties-common --no-install-recommends --yes
RUN add-apt-repository ppa:ubuntu-mozilla-daily
RUN apt-get update
RUN apt-get --no-install-recommends --yes install firefox-trunk dumb-init socat fontconfig && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
