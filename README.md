# Ruby 1.8 / Rails 1.2.6 Docker Image

It's really hard to run Rails 1.2 apps these days.
This Dockerfile will do it.

**TODO:** Add nginx or Apache production server (must use Passenger 3.0.21)

## Usage

Runs as "appuser", so just mount your project at /home/appuser/project.
Here is how to run script/server using this image, given that you have a
Rails 1.2.6 app named "myapp":

```bash
cd myapp
docker run -itv $PWD:/home/appuser/myapp ruby-1.8:rails-1.2 ./myapp/script/server
```

## Rails 2.3

Can also be used as a basis for a Docker image for running Rails 2.3 apps,
just install different gems, or use a bundler-based setup.
