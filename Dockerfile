FROM ubuntu:focal

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install firefox=77\* dumb-init build-essential ruby ruby-dev gem socat wget fontconfig && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

RUN wget https://ftp.mozilla.org/pub/firefox/releases/77.0.1/linux-x86_64/en-US/firefox-77.0.1.tar.bz2 --no-check-certificate
RUN tar -xjf firefox-77.0.1.tar.bz2
RUN mv firefox /opt/firefox76
RUN rm /usr/bin/firefox
RUN ln -s /opt/firefox76/firefox-bin /usr/bin/firefox

# install God
RUN gem install god

VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/
COPY --chown=firefox:firefox firefox.god /home/firefox/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
