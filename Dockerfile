FROM ubuntu:focal

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install firefox=91\* dumb-init curl build-essential ruby ruby-dev gem socat wget fontconfig && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

# install God
RUN gem install god

# Install firefox
RUN curl --location "https://ftp.mozilla.org/pub/firefox/releases/91.0.2/linux-x86_64/en-US/firefox-91.0.2.tar.bz2" \
  | tar --extract --verbose --preserve-permissions --bzip2

RUN mv firefox /home/firefox/developer-firefox
RUN ln -s /home/firefox/developer-firefox/firefox /usr/bin/firefox-dev

VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/
COPY --chown=firefox:firefox firefox.god /home/firefox/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
