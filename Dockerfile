FROM python:alpine
LABEL maintainer Xueshan Feng <xueshan.feng@gmail.com>

RUN apk --no-cache --update add \
	curl \
        ca-certificates \
	bash \
        inotify-tools \
	openssl

RUN apk --update add --virtual build-dependencies \
  python-dev \
  build-base \
  openssl-dev \
  libffi-dev \
  && pip install dns-lexicon==3.3.0 dns-lexicon[route53]==3.3.0 boto3 \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*

VOLUME ["/letsencrypt"]
RUN mkdir /dns
ADD https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh /dns/hook
ADD https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated  ./dehydrated
COPY run.sh config /
RUN chmod +x /dns/hook /run.sh ./dehydrated

ENTRYPOINT ["/bin/bash"]
CMD ["/run.sh"]
