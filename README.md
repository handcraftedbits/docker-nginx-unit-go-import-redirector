# NGINX Host go-import-redirector Unit [![Docker Pulls](https://img.shields.io/docker/pulls/handcraftedbits/nginx-unit-go-import-redirector.svg?maxAge=2592000)](https://hub.docker.com/r/handcraftedbits/nginx-unit-go-import-redirector)

A [Docker](https://www.docker.com) container that provides a go-import-redirector unit for
[NGINX Host](https://github.com/handcraftedbits/docker-nginx-host).

This container makes use of [rsc/go-import-redirector](https://github.com/rsc/go-import-redirector) to create a server
for custom [Go import paths](https://golang.org/cmd/go/#hdr-Remote_import_paths).

# Usage

## Configuration

It is highly recommended that you use container orchestration software such as
[Docker Compose](https://www.docker.com/products/docker-compose) when using this NGINX Host unit as several Docker
containers are required for operation.  This guide will assume that you are using Docker Compose.

To begin, start with a basic `docker-compose.yml` file as described in the
[NGINX Host configuration guide](https://github.com/handcraftedbits/docker-nginx-host#configuration).  Then, add a
service for the NGINX Host go-import-redirector unit (named `redirector`):

```yaml
redirector:
  image: handcraftedbits/nginx-unit-go-import-redirector
  environment:
    - NGINX_UNIT_HOSTS=mysite.com
    - NGINX_URL_PREFIX=/go
    - REDIRECTOR_IMPORT=mysite.com/go/*
    - REDIRECTOR_REPO=https://github.com/mysite/*
  volumes:
    - data:/opt/container/shared
```

Observe the following:

* Several environment variables are used to configure go-import-redirector.  See the
  [environment variable reference](#reference) and
  [go-import-redirector documentation](https://godoc.org/rsc.io/go-import-redirector) for additional information.
* As with any other NGINX Host unit, we mount our data volume, in this case named `data`, to `/opt/container/shared`.

Finally, we need to create a link in our NGINX Host container to the `redirector` container in order to host
go-import-redirector.  Here is our final `docker-compose.yml` file:

```yaml
version: "2.1"

volumes:
  data:

services:
  proxy:
    image: handcraftedbits/nginx-host
    links:
      - redirector
    ports:
      - "443:443"
    volumes:
      - data:/opt/container/shared
      - /etc/letsencrypt:/etc/letsencrypt
      - /home/me/dhparam.pem:/etc/ssl/dhparam.pem

  redirector:
    image: handcraftedbits/nginx-unit-go-import-redirector
    environment:
      - NGINX_UNIT_HOSTS=mysite.com
      - NGINX_URL_PREFIX=/go
      - REDIRECTOR_IMPORT=mysite.com/go/*
      - REDIRECTOR_REPO=https://github.com/mysite/*
    volumes:
      - data:/opt/container/shared
```

This will result in making go-import-redirector available at `https://mysite.com/go/*`.

## Running the NGINX Host go-import-redirector Unit

Assuming you are using Docker Compose, simply run `docker-compose up` in the same directory as your
`docker-compose.yml` file.  Otherwise, you will need to start each container with `docker run` or a suitable
alternative, making sure to add the appropriate environment variables and volume references.

# Reference

## Environment Variables

### `REDIRECTOR_IMPORT`

Used to specify the import path pattern.  For example, `mysite.com/go/*`.

**Required**

### `REDIRECTOR_REPO`

Used to specify the underlying repository URL that hosts Go code.

**Required**

### `REDIRECTOR_VCS`

Used to specify which version control system is represented by the underlying repository URL.

**Default**: `git`
**Acceptable values**: `git`, `hg`, `svn`

### Others

Please see the NGINX Host [documentation](https://github.com/handcraftedbits/docker-nginx-host#units) for information
on additional environment variables understood by this unit.
