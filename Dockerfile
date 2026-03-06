FROM ubuntu:latest
RUN apt-get update && apt-get install -y --no-install-recommends \
    ttyd \
    tini \
    bash \
    mc \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Zapisz aktualną listę katalogów w / do pliku podczas budowania
RUN ls / > /etc/system_dirs_snapshot.txt

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7681
WORKDIR /root
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]