FROM python:latest
LABEL maintainer Marshall Lai <lai.marshall@gmail.com> 

RUN apt-get update \
 && apt-get install -y\
      inotify-tools \
      curl
      
RUN pip install \
      dns-lexicon

VOLUME ["/letsencrypt"]
RUN mkdir /dns
ADD https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh /dns/hook
ADD https://raw.githubusercontent.com/lukas2511/dehydrated/master/dehydrated  ./dehydrated
COPY run.sh config ./
RUN chmod +x ./dehydrated /dns/hook ./run.sh

ENTRYPOINT ["/bin/bash"]
CMD ["./run.sh"]
