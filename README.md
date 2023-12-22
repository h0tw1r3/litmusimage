# litmusimage

[![Nightly][nightly-badge]][nightly-workflow]
[![CI/CD][ci-badge]][ci-workflow]
[![License][license-badge]](LICENSE)

This repository creates docker image files for testing puppet modules with
[Puppet Litmus][1].

The images have initd, systemd or upstart, along with SSH.

Images get uploaded to [Docker Hub][2] automatically and are rebuilt [nightly if
necessary][3].

## Buildable images

| image           | tag     | dockerfile         | base_image            | base_tag |
| -----           | ---     | ----------         | ----------            | -------- |
| ubuntu          | 18.04   | apt_sysvinit-utils | ubuntu                | 18.04 |
| ubuntu          | 20.04   | apt_sysvinit-utils | ubuntu                | 20.04 |
| ubuntu          | 22.04   | apt_sysvinit-utils | ubuntu                | 22.04 |
| centos          | 6       | yum_initd          | centos                | 6 |
| centos          | 7       | yum_systemd        | centos                | 7 |
| centos          | stream8 | yum_systemd        | quay.io/centos/centos | stream8 |
| centos          | stream9 | yum_systemd        | quay.io/centos/centos | stream9 |
| scientificlinux | 6       | yum_initd          | scientificlinux/sl    | 6 |
| scientificlinux | 7       | yum_systemd        | scientificlinux/sl    | 7 |
| oraclelinux     | 6       | yum_initd          | oraclelinux           | 6 |
| oraclelinux     | 7       | yum_systemd        | oraclelinux           | 7 |
| oraclelinux     | 8       | yum_systemd        | oraclelinux           | 8 |
| oraclelinux     | 9       | yum_systemd        | oraclelinux           | 9 |
| rockylinux      | 8       | yum_systemd        | rockylinux/rockylinux | 8 |
| rockylinux      | 9       | yum_systemd        | rockylinux/rockylinux | 9 |
| almalinux       | 8       | yum_systemd        | almalinux             | 8 |
| almalinux       | 9       | yum_systemd        | almalinux             | 9 |
| debian          | 10      | apt_sysvinit-utils | debian                | 10 |
| debian          | 11      | apt_sysvinit-utils | debian                | bullseye |
| debian          | 12      | apt_sysvinit-utils | debian                | 12 |
| amazonlinux     | 2       | yum_systemd        | amazonlinux           | 2 |
| amazonlinux     | 2023    | yum_systemd        | amazonlinux           | 2023 |
| fedora          | 36      | yum_systemd        | fedora                | 36 |

## Manual Building

```bash
docker build --rm --no-cache -t litmusimage/${IMAGE}:${TAG} . \
  -f ${DOCKERFILE}.dockerfile \
  --build-arg BASE_TAG=${BASE_TAG} \
  --build-arg OS_TYPE=${BASE_IMAGE}
```

For example with:

```bash
BASE_IMAGE=ubuntu
DOCKERFILE=apt_sysvinit-utils
IMAGE=ubuntu
TAG=22.04
BASE_TAG=${TAG}
```

The build command would be:

```bash
docker build --rm --no-cache -t litmusimage/ubuntu:22.04 . \
  -f apt_sysvinit-utils.dockerfile \
  --build-arg BASE_TAG=22.04 \
  --build-arg OS_TYPE=ubuntu
```

## Push said image

```bash
# docker login
docker image push litmusimage/centos:stream9
```

## Tips and tricks for docker wrangling

```bash
# List running and stopped containers
docker container ls -a

# remove a container
docker rm -f ubuntu_20.04-2224

# remove all containers
docker rm -f $(docker ps -a -q)

# jump into a container, force a shell
docker exec -it litmusimage_debian11_-2223 /bin/bash

# attach to a container ( limited by what pid 0 is)
docker attach litmusimage_ubuntu22.04_-2222

# safely exit a container, leaving it running
<ctrl> + p then <ctrl> + q

# get the latest version of the image
docker pull debian:10

# show the history of the image
docker image history litmusimage/ubuntu22.04

# remove all docker images that are on your local machine
docker rmi $(docker images -q)
```

## Add new images

* Add/change dockerfile for the new image
* Every dockerfile needs a `base_image` label where the base image id will be
  stored. This will be used in the [nightly build][3] to identify if the base image
  has been updated.
* Change [images.json][4] to build the new images with CI
* New images will be pushed to [Docker Hub][2] only on pushes to the main branch,
  and will be [updated nightly][3] in case the base image has changed.

## Future improvements

* Introduce variants with puppet agent pre-installed for `litmus:install_agent`

## Repository

This project supports continuous integration with [Github Actions] workflows.
Repository actions are configured by default to build and deploy container
images to your [Github packages] project repository.

To configure a registry such as [docker.io], create these Action secrets and
variables:

| variable            | value              | type   |
| ------------------- | ------------------ | ------ |
| `DOCKER_USERNAME`   | _your login_       |        |
| `DOCKER_PASSWORD`   | _read/write token_ | secret |
| `DOCKER_REGISTRY`   | `docker.io`        |        |
| `DOCKER_REPOSITORY` | _your login_       |        |

[1]: https://github.com/h0tw1r3/puppetlitmus
[2]: https://github.com/h0tw1r3?ecosystem=container&tab=packages&tab=packages&ecosystem=container&q=litmusimage
[3]: https://github.com/h0tw1r3/litmusimage/blob/main/.github/workflows/nightly.yml
[4]: https://github.com/h0tw1r3/litmusimage/tree/main/images.json

[Github Packages]: https://ghcr.io
[Github Actions]: https://docs.github.com/en/actions
[docker.io]: https://docker.io

[nightly-badge]: https://github.com/h0tw1r3/litmusimage/actions/workflows/nightly.yml/badge.svg
[nightly-workflow]: https://github.com/h0tw1r3/litmusimage/actions/workflows/nightly.yml
[ci-badge]: https://github.com/h0tw1r3/litmusimage/actions/workflows/ci.yml/badge.svg
[ci-workflow]: https://github.com/h0tw1r3/litmusimage/actions/workflows/ci.yml
[license-badge]: https://img.shields.io/badge/License-Apache_2.0-blue.svg
