FROM debian:8
LABEL rails="1.2.6" ruby="1.8.7-p375"
EXPOSE 3000
WORKDIR /root
USER root

RUN apt-get update
RUN apt-get upgrade -y
# Need eastern time for Rails 1.2 to know where we are
ADD timezone /etc/
RUN dpkg-reconfigure -f noninteractive tzdata
# Install basic build and runtime requirements for Ruby 1.8
RUN apt-get install -y \
  autoconf \
  bison \
  build-essential \
  git \
  imagemagick \
  libmagickwand-dev \
  libpq-dev \
  libreadline6 \
  libreadline-dev \
  libssl-dev \
  subversion \
  wget

# Install ruby-build
RUN wget https://github.com/rbenv/ruby-build/archive/v20180601.tar.gz && \
  tar -xf v20180601.tar.gz && \
  cd ruby-build-20180601 && \
  ./install.sh

# Install ruby
RUN mkdir -p /opt/rubies
RUN ruby-build -v 1.8.7-p375 /opt/rubies/1.8.7-p375
ENV PATH /opt/rubies/1.8.7-p375/bin:$PATH

# Install gems

# Seems to be the newest version that works with Rails 1 apps
RUN gem install rake -v 0.7.3

# Allows Rails 2.3 and older to be installed.
RUN gem install slimgems

# Lock some basics to versions that work on Ruby 1.8
RUN gem install i18n -v 0.6.11
RUN gem install json -v 1.8.3

# Install rails
RUN gem install rails -v 1.2.6

# Need this specific postgres gem for Rails 1.2.
RUN gem install postgres -v 0.7.9.2008.01.28

# Activemerchant dependencies
RUN gem install money -v 4.0.2
RUN gem install httpclient -v 2.1.5
RUN gem install soap4r -v 1.5.8

# Image manipulation gem used by many apps
RUN gem install rmagick -v 2.15.4

# Create a user to run the app as (put it last so it can be changed more easily)
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser

RUN mkdir -p /app && chown -R appuser:appuser /app

USER appuser
WORKDIR /app

CMD ["bash"]
