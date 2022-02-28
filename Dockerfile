FROM ubuntu:focal

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends --yes install firefox=97\* dumb-init curl build-essential ruby ruby-dev gem socat wget fontconfig && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

# install latest https://github.com/kostya/eye
# need git in apt-get
# RUN git clone https://github.com/kostya/eye.git && \
#   cd eye && \
#   gem build eye.gemspec && \
#   gem install eye-0.10.1.pre.gem && \
#   cd .. && \
#   rm -rf eye

# install pre built gem
COPY eye-0.10.1.pre.gem /tmp/
RUN gem install /tmp/eye-0.10.1.pre.gem -N && rm /tmp/eye-0.10.1.pre.gem

# Install firefox
RUN curl --location "https://ftp.mozilla.org/pub/firefox/releases/97.0.1/linux-x86_64/en-US/firefox-97.0.1.tar.bz2" \
  | tar --extract --verbose --preserve-permissions --bzip2

RUN mv firefox /home/firefox/developer-firefox
RUN ln -s /home/firefox/developer-firefox/firefox /usr/bin/firefox-dev

VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/
COPY --chown=firefox:firefox firefox.eye /home/firefox/

USER firefox

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
