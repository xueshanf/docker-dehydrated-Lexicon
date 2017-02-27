FROM hyper/dehydrated:latest
LABEL maintainer Marshall Lai <lai.marshall@gmail.com> 

RUN apt-get update \
 && apt-get install -y \
      curl \
      inotify-tools \
      python2.7 \
      python-pip

RUN pip install \
      dns-lexicon

VOLUME ["/letsencrypt"]
ADD https://raw.githubusercontent.com/AnalogJ/lexicon/master/examples/dehydrated.default.sh /dns/hook

COPY run.sh config /
RUN chmod +x /dns/hook /run.sh /letsencrypt.sh

ENTRYPOINT ["/bin/bash"]
CMD ["/run.sh"]