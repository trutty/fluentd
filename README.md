# Overview
Builds a fluentd Docker image based on alpine Linux for use in a Kubernetes environment.

All plugins and dependencies for fluentd are listed in the `Gemfile` and are directly installed in the image.

The image will run as a non-root user called `fluent` with uid `1000`.

# Kubernetes
During startup, fluentd will search for additional configuraion files in `/etc/fluent/config.d/*.conf`. Make sure to have a ConfigMap with your config mounted in this location.
