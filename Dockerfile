FROM python:alpine
LABEL maintainer Marshall Lai <lai.marshall@gmail.com> 

RUN apk --no-cache --update add \
	curl \
        ca-certificates \
	bash \
        inotify-tools \
	openssl

RUN pip install boto3

RUN apk --update add --virtual build-dependencies \
  python-dev \
  build-base \
  openssl-dev \
  libffi-dev \
  && pip install dns-lexicon[route53] boto3 \
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
