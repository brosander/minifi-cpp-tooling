FROM ubuntu:xenial

ARG UID=1000
ARG GID=50

RUN apt-get update && \
    apt-get install -y \
      git \
      cmake \
      gcc g++ \
      libcurl4-openssl-dev \
      libleveldb-dev libleveldb1v5 \
      uuid-dev uuid \
      libboost-all-dev libssl-dev \
      doxygen && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g $GID minifi || groupmod -n minifi `getent group $GID | cut -d: -f1` && \
    useradd --shell /bin/bash -u $UID -g $GID -m minifi && \
    mkdir -p /home/minifi && \
    chown -R minifi:minifi /home/minifi

ADD start.sh /home/minifi/
RUN chown minifi:minifi /home/minifi/start.sh && chmod 500 /home/minifi/start.sh
VOLUME /build
RUN chown minifi:minifi /build
USER minifi
ENTRYPOINT ["/home/minifi/start.sh"]
