FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y cups && \
    sed -i 's/Listen localhost:631/Port 631/' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/>/,/<\/Location>/ s/Require local/Allow all/' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/admin>/,/<\/Location>/ s/Require local/Allow all/' /etc/cups/cupsd.conf && \
    sed -i '/<Location \/admin\/conf>/,/<\/Location>/ s/Require local/Allow all/' /etc/cups/cupsd.conf && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/usr/sbin/cupsd", "-f"]
