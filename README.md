[![Build Status](https://travis-ci.com/tiangolo/docker-with-compose.svg?branch=master)](https://travis-ci.com/tiangolo/docker-with-compose)

## Supported tags and respective `Dockerfile` links

* [`latest` _(Dockerfile)_](https://github.com/tiangolo/docker-with-compose/blob/master/Dockerfile)

# Docker with Docker Compose image

[Docker image](https://hub.docker.com/_/docker/) with [Docker Compose](https://github.com/docker/compose) installed for CI.

## Description

The main purpose of this image is to help in Continuous Integration environments that need the `docker` binary, the `docker-compose` binary, and possibly require doing other small things, like running shell scripts or notifying some API with `curl`.

It includes both programs (`docker` and `docker-compose`) and allows to run arbitrary shell scripts (contrary to the official Docker Compose image).

By not having to install `docker-compose` on top of a `docker:latest` image it can reduce the building time about 10 / 15 seconds in a cloud data center for each build. In environments in where the Internet connection is less good than a cloud provider, the time saved would be more.

**GitHub repo**: <https://github.com/tiangolo/docker-with-compose>

**Docker Hub image**: <https://hub.docker.com/r/tiangolo/docker-with-compose/>

## Usage

Pull the image:

```bash
docker pull tiangolo/docker-with-compose
```

Then run a container of this image **mounting the Docker sock** as a host volume.

By mounting the Docker sock as a volume you allow the `docker` client inside of the container to communicate with your Docker (the Docker daemon/service) on your machine directly.

This way, you can send Docker commands, like pulling, running, or building a new Docker image, from inside this container.

You might also want to mount a host volume with the files that you need to use.

---

For example, let's say you have a `Dockerfile` like:

```Dockerfile
FROM nginx

RUN echo "Hello World" > /usr/share/nginx/html/index.html
```

You could:

* Mount the local directory containing that `Dockerfile`.
* Mount the local Docker sock.
* Build that Nginx image from inside of container running this image.

```bash
docker run -v $(pwd):/app -v /var/run/docker.sock:/var/run/docker.sock tiangolo/docker-with-compose sh -c "cd /app/ && docker build -t custom-nginx ."
```

## Problem description

There is an official [Docker image](https://hub.docker.com/_/docker/) that contains the `docker` binary. And there is a [Docker Compose image](https://hub.docker.com/r/docker/compose/).

But the Docker Compose image has `docker-compose` as the entrypoint.

So, it's not possible to run other commands on that image, like installing something, e.g. `apt-get install -y curl`.

And it's also not possible to run `docker` commands directly, e.g. `docker login -u ci-user -p $CI_JOB_TOKEN $CI_REGISTRY`.

This image allows running arbitrary commands like Bash scripts, `docker` commands and also Docker Compose commands like `docker-compose build` and `docker-compose push`.

As several Continuous Integration systems allow doing previous steps, like installing packages before running the actual main script, those steps could be used to install Docker Compose. But by downloading and installing Docker Compose every time, the builds would be slower.

For example, a very simple GitLab CI file `.gitlab-ci.yml` could look like:

```yml
# Do not use this file example
image: docker:latest

before_script:
  - apk add --no-cache py-pip
  - pip install docker-compose
  - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY

ci:
  script:
    - docker-compose build
    - docker-compose up -d
    - docker-compose exec -T tests run-tests.sh
    - docker-compose down -v
    - docker stack deploy -c docker-compose.prod.yml --with-registry-auth prod-example-com
```

But when the base image has to download and install Docker Compose every time, that's time added to the process. Specifically the lines in:

```yml
...

  - apk add --no-cache py-pip
  - pip install docker-compose

...
```

## This image's solution

This image includes Docker Compose and allows you to run any other arbitrary command.

So your GitLab CI `.gitlab-ci.yml` file could then look like:

```yml
image: tiangolo/docker-with-compose

before_script:
  - docker login -u gitlab-ci-token -p $CI_JOB_TOKEN $CI_REGISTRY

ci:
  script:
    - docker-compose build
    - docker-compose up -d
    - docker-compose exec -T tests run-tests.sh
    - docker-compose down -v
    - docker stack deploy -c docker-compose.prod.yml --with-registry-auth prod-example-com
```

And it would run faster as it doesn't have to install Docker Compose every time.

And you could start that initial GitLab Runner following the [GitLab CI runner for CI/CD guide on DockerSwarm.rocks](https://dockerswarm.rocks/gitlab-ci/).

The same would apply for Travis, Jenkins or whichever CI system you use.

## Release Notes

### Latest Changes

* 👷 Add Latest Changes GitHub Action. PR [#24](https://github.com/tiangolo/docker-with-compose/pull/24) by [@tiangolo](https://github.com/tiangolo).
* Upgrade Python to use version 3.x. PR [#15](https://github.com/tiangolo/docker-with-compose/pull/15).
* Add `curl` to the installed and available packages. PR [#14](https://github.com/tiangolo/docker-with-compose/pull/14) by [@stratosgear](https://github.com/stratosgear).
* Add Travis CI. PR [#4](https://github.com/tiangolo/docker-with-compose/pull/4).
* Upgrade Docker Compose installation. PR [#3](https://github.com/tiangolo/docker-with-compose/pull/3) by [@boskiv](https://github.com/boskiv).

## License

This project is licensed under the terms of the MIT license.
