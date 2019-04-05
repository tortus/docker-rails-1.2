# Ruby 1.8 / Rails 1.2.6 Docker Image

**WARNING:** Intended only to aid upgrades and reviewing old apps. Not for use
in production!!!

It's really hard to run Rails 1.2 apps these days. This Docker image will do it.
Use as a base to construct a docker image for a Rails 1.2 app.

**TODO:** Add nginx or Apache production server (must use Passenger 3.0.21)

## Paths

* Ruby is in `/opt/rubies/1.8.7-p375`, and the bin directory is in the PATH.
* Put your app anywhere you want. Performance when running off a shared volume
  is terrible in my experience, so you may prefer to bake it into the image.

## Gems

Comes with the following gems pre-installed:

* rake 0.7.3
* slimgems
* i18n 0.6.11
* json 1.8.3
* rails 1.2.6

Those specific versions of i18n and json are the latest that will work on Ruby
1.8, and are needed by most apps. Rake 0.7.3 is the latest version of rake that
will work with Rails 1.2, and is required by slimgems.

## Packages

The following packages are added to the base image:

* ca-certificates

## Gems with C-Extensions

The dependencies for these can be varied. Generally you will want to at least
install `gcc` and `make`, but these have been omitted from the final image to
save space in case they are not needed.
