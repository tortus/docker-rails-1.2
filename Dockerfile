FROM debian:8
MAINTAINER Tortus Tek Inc
EXPOSE 3000
WORKDIR /root
USER root

RUN apt-get update
# Fix a stupid warning
RUN apt-get install -y --no-install-recommends apt-utils
# Do a full update
RUN apt-get upgrade -y
# Install basic build and runtime requirements for Ruby 1.8
RUN apt-get install -y autoconf subversion bison build-essential libssl-dev git wget readline libreadline-dev

# Install ruby-build
RUN wget https://github.com/rbenv/ruby-build/archive/v20180601.tar.gz
RUN tar -xf v20180601.tar.gz && cd ruby-build-20180601 && ./install.sh

# Install ruby
RUN mkdir -p /opt/rubies
RUN ruby-build -v 1.8.7-p375 /opt/rubies/ruby-1.8.7-p375
ENV PATH /opt/rubies/ruby-1.8.7-p375/bin:$PATH

# Install gems

# Lock bundler to a specific version, in case future versions drop Ruby 1.8
RUN gem install bundler -v 1.10.6
# Some very old apps need rake 0.7.3, so we may as well install it.
RUN gem install rake -v 0.7.3
# The version of rake we will use more often.
RUN gem install rake -v 0.8.7

# Allows Rails 2.3 and older to be installed.
RUN gem install slimgems

# Lock some basics to versions that work on Ruby 1.8
RUN gem install i18n -v 0.6.11
RUN gem install json -v 1.8.3

# Install rails
RUN gem install rails -v 1.2.6

# Need this specific postgres gem for Rails 1.2.
# Having postgresql-client (psql) installed is just useful, but it can be removed.
RUN apt-get install -y libpq-dev postgresql-client
RUN gem install postgres -v 0.7.9.2008.01.28

# Activemerchant dependencies
RUN gem install money -v 4.0.2
RUN gem install httpclient -v 2.1.5
RUN gem install soap4r -v 1.5.8

# Image manipulation gem used by many apps
RUN apt-get install -y imagemagick libmagickwand-dev
RUN gem install rmagick -v 2.15.4

# Set a time zone, since Rails 1.2 doesn't do UTC well
ADD timezone /etc/
RUN dpkg-reconfigure -f noninteractive tzdata

# Create a user to run the app as (put it last so it can be changed more easily)
RUN groupadd -g 999 appuser && \
    useradd -r -u 999 -g appuser appuser

USER appuser
WORKDIR /home/appuser
CMD ["bash"]
