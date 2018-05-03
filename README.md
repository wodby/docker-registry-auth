# Docker Registry Authentication Server Container Image

[![Build Status](https://travis-ci.org/wodby/docker-registry-auth.svg?branch=master)](https://travis-ci.org/wodby/docker-registry-auth)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/docker-registry-auth.svg)](https://hub.docker.com/r/wodby/docker-registry-auth)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/docker-registry-auth.svg)](https://hub.docker.com/r/wodby/docker-registry-auth)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/docker-registry-auth.svg)](https://microbadger.com/images/wodby/docker-registry-auth)

## Docker Images

!!! For better reliability we release images with stability tags (`wodby/docker-registry-auth:1.3-X.X.X`) which correspond to [git tags](https://github.com/wodby/docker-registry-auth/releases). We **STRONGLY RECOMMEND** using images only with stability tags. 

Overview:

* All images are based on Alpine Linux
* Base image: [wodby/php](https://github.com/wodby/php)
* [Travis CI builds](https://travis-ci.org/wodby/docker-registry-auth) 
* [Docker Hub](https://hub.docker.com/r/wodby/docker-registry-auth)

Supported tags and respective `Dockerfile` links:

* `1`, `1.3`, `latest`  [_(Dockerfile)_](https://github.com/wodby/docker-registry-auth/tree/master/Dockerfile)

## Environment Variables

| Variable                        | Default Value    | Description |
| ------------------------------- | ---------------- | ----------- |
| `REGISTRY_AUTH_ADDRESS`         | `:5001`          |             |
| `REGISTRY_AUTH_ADMIN_PASSWORD`  |                  |             |
| `REGISTRY_AUTH_ADMIN_USER`      | `admin`          |             |
| `REGISTRY_AUTH_CALLBACK`        |                  |             |
| `REGISTRY_AUTH_CERT`            |                  |             |
| `REGISTRY_AUTH_EXPIRATION`      | `3600`           |             |
| `REGISTRY_AUTH_ISSUER`          | `Example issuer` |             |
| `REGISTRY_AUTH_KEY`             |                  |             |
| `REGISTRY_AUTH_USERS`           |                  |             |

See [wodby/php](https://github.com/wodby/php) for all variables

## Orchestration actions

Usage:
```
make COMMAND [params ...]

commands:
    check-ready [host port max_try wait_seconds delay_seconds]
 
default params values:
    host localhost
    port 5001
    max_try 1
    wait_seconds 1
    delay_seconds 0
```
