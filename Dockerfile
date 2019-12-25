FROM alpine:3.11.2
LABEL maintainer="github.com/robertbeal"

ARG ARCH=amd64

RUN adduser -s /bin/false -D -h /data -u 6100 dasshio \
  && apk add --no-cache --virtual=build-dependencies \
    alpine-sdk \
    gcc \
    linux-headers \
    musl-dev \
    python3-dev \
    wget \
  && apk add --no-cache \
    curl \
    python3 \
    tcpdump \
  && wget -O /tmp/requirements.txt https://raw.githubusercontent.com/danimtb/dasshio/master/dasshio/requirements.txt \
  && wget https://raw.githubusercontent.com/danimtb/dasshio/master/dasshio/config.json \
  && wget https://raw.githubusercontent.com/danimtb/dasshio/master/dasshio/dasshio.py \
  && echo '{ "timeout":20, "buttons": []}' > /data/options.json \
  && pip3 install --requirement /tmp/requirements.txt \
  && apk del --purge build-dependencies \
  && rm -rf /tmp/*

VOLUME /data
USER dasshio
CMD ["/usr/bin/python3", "dasshio.py"]
