FROM gcr.io/google_containers/ubuntu-slim:0.9

RUN apt-get update && \
    apt-get install -y iperf && \
    rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh

CMD ["/run.sh"]