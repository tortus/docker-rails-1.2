FROM debian:8
LABEL rails="1.2.6" ruby="1.8.7-p375"
WORKDIR /root
USER root

RUN apt-get update
RUN apt-get upgrade -y
# Install basic build and runtime requirements for Ruby 1.8
RUN apt-get install -y \
  autoconf \
  bison \
  build-essential \
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

# Install versions of i18n and json that work with Rails 1.2 and Ruby 1.8
RUN gem install i18n -v 0.6.11
RUN gem install json -v 1.8.3

# Install rails
RUN gem install rails -v 1.2.6

CMD ["irb"]
