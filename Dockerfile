FROM tortus/ruby-1.8:1.0.0

RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  apt-get install -y --no-install-recommends \
    gcc make libc6-dev && \
  gem install i18n -v 0.6.11 --no-ri --no-rdoc && \
  gem install json -v 1.8.3 --no-ri --no-rdoc && \
  gem install rails -v 1.2.6 --no-ri --no-rdoc && \
  apt-get purge -y --auto-remove gcc make libc6-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

LABEL rails="1.2.6" ruby="1.8.7-p375"
