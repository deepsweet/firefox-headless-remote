FROM ubuntu:eoan

RUN apt-get update && \
    apt-get --no-install-recommends --yes install firefox=69\* dumb-init socat wget fontconfig && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

RUN wget https://ftp.mozilla.org/pub/firefox/releases/68.0/linux-x86_64/en-US/firefox-68.0.tar.bz2 --no-check-certificate
RUN tar -xjf firefox-68.0.tar.bz2
RUN mv firefox /opt/firefox68
RUN rm /usr/bin/firefox
RUN ln -s /opt/firefox68/firefox-bin /usr/bin/firefox

VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]