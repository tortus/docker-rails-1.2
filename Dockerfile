FROM debian:8
LABEL rails="1.2.6" ruby="1.8.7-p375"
WORKDIR /root
USER root

ENV RUBY_VERSION="1.8.7-p375"
ENV RUBY_BUILD_VERSION="20180601"
ENV RUBY_BUILD_URL="https://github.com/rbenv/ruby-build/archive/v${RUBY_BUILD_VERSION}.tar.gz"

# This needs to be done so packages can be installed now that Debian 8 is EOL.
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && \
  sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list

# Install ruby-build and use it to build Ruby 1.8.7-p375.
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  apt-get install -y --no-install-recommends \
    autoconf \
    bison \
    build-essential \
    ca-certificates \
    libreadline6 \
    libreadline-dev \
    libssl-dev \
    subversion \
    wget && \
  wget -O ruby-build.tar.gz ${RUBY_BUILD_URL} && \
  tar -xf ruby-build.tar.gz && \
  cd ruby-build-${RUBY_BUILD_VERSION} && ./install.sh && \
  cd .. && rm ruby-build.tar.gz && rm -rf ruby-build-${RUBY_BUILD_VERSION} && \
  mkdir -p /opt/rubies && \
  /usr/local/bin/ruby-build -v ${RUBY_VERSION} /opt/rubies/${RUBY_VERSION} && \
  apt-get purge -y --auto-remove \
    autoconf \
    bison \
    build-essential \
    libreadline-dev \
    libssl-dev \
    subversion \
    wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /usr/local/ruby-build

ENV PATH="/opt/rubies/${RUBY_VERSION}/bin:${PATH}"

# == Install gems
#
# - rake 0.7.3: Seems to be the newest version that works with Rails 1 apps. Required by slimgems.
# - slimgems: Allows Rails 2.3 and older to be installed.
# - i18n 0.6.11 and json 1.8.3: latest versions that work with rails 1.2 and ruby 1.8
RUN apt-get -o Acquire::Check-Valid-Until=false update && \
  apt-get install -y --no-install-recommends gcc make libc6-dev && \
  gem install rake -v 0.7.3 && \
  gem install slimgems && \
  gem install i18n -v 0.6.11 && \
  gem install json -v 1.8.3 && \
  gem install rails -v 1.2.6 && \
  apt-get purge -y --auto-remove gcc make libc6-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

CMD ["/opt/rubies/${RUBY_VERSION}/bin/irb"]
