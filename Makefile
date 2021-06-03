AUTH_SERVER_VER ?= 1.7.0
ALPINE_VER ?= 3.13

REPO = wodby/docker-registry-auth
NAME = docker-registry-auth-$(AUTH_SERVER_VER)

PLATFORM ?= linux/amd64

ifeq ($(TAG),)
    TAG ?= $(AUTH_SERVER_VER)
endif

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build buildx-build buildx-build-amd64 buildx-push test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) --build-arg AUTH_SERVER_VER=$(AUTH_SERVER_VER) ./

# --load doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 -t $(REPO):$(TAG) \
		--build-arg AUTH_SERVER_VER=$(AUTH_SERVER_VER) \
		--build-arg ALPINE_VER=$(ALPINE_VER) \
		--load \
		./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
		--build-arg AUTH_SERVER_VER=$(AUTH_SERVER_VER) \
		--build-arg ALPINE_VER=$(ALPINE_VER) \
		./

buildx-push:
	docker buildx build --platform $(PLATFORM) --push -t $(REPO):$(TAG) \
		--build-arg AUTH_SERVER_VER=$(AUTH_SERVER_VER) \
		--build-arg ALPINE_VER=$(ALPINE_VER) \
		./

test:
	./tests.sh $(REPO):$(TAG)

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push