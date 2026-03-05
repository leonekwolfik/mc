FROM ubuntu:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    ttyd \
    tini \
    bash \
    mc \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN chmod +x /usr/bin/ttyd

EXPOSE 7681
WORKDIR /root

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "-W", "bash"]