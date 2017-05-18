FROM gcr.io/google_containers/ubuntu-slim:0.9

RUN apt-get update && \
    apt-get install -y wget && \
    apt-get install -y build-essential && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    wget ftp://ftp.netperf.org/netperf/netperf-2.7.0.tar.gz && \
    tar xzvf netperf-2.7.0.tar.gz && \
    cd netperf-2.7.0/ && \
    ./configure && make &&  make check && make install && make clean && \
    cd / && rm -rf netperf-2.7.0/ netperf-2.7.0.tar.gz && \
    apt-get remove -y wget && \
    apt-get remove -y build-essential && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* 

COPY run.sh /run.sh

CMD ["/run.sh"]