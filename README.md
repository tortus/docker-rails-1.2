# Ruby 1.8 / Rails 1.2.6 Docker Image

It's really hard to run Rails 1.2 apps these days.
This Dockerfile will do it. Use as a base to construct a docker
image for a Rails 1.2 app.

**TODO:** Add nginx or Apache production server (must use Passenger 3.0.21)

## Gems

Comes with the following pre-installed:

* rake 0.7.3
* slimgems
* i18n 0.6.11
* json 1.8.3

Those specific versions of 18n and json are the latest that will work on Ruby 1.8, and are needed by most apps. Rake 0.7.3 is the latest version of rake that will work with Rails 1.2.
