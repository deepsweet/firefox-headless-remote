FROM ubuntu:disco

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    # https://github.com/phusion/baseimage-docker/issues/319
    apt-get --yes install apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" && \
    apt-get --no-install-recommends --yes install firefox=68\* dumb-init socat fontconfig && \
    groupadd firefox && \
    useradd --create-home --gid firefox firefox && \
    chown --recursive firefox:firefox /home/firefox/

VOLUME ["/home/firefox/.fonts"]

COPY --chown=firefox:firefox entrypoint.sh /home/firefox/
COPY --chown=firefox:firefox profile/ /home/firefox/profile/

USER firefox

EXPOSE 2828

ENTRYPOINT ["dumb-init", "--", "/bin/sh", "/home/firefox/entrypoint.sh"]
