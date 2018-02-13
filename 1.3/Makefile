-include .env

APP_VER ?= 1.3

REPO = wodby/docker-registry-auth
NAME = docker-registry-auth-$(APP_VER)

ifeq ($(TAG),)
    TAG ?= $(APP_VER)
endif

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build
build:
	docker build -t $(REPO):$(TAG) ./

.PHONY: test
test:
	IMAGE=$(REPO):$(TAG) ./test.sh

.PHONY: push
push:
	docker push $(REPO):$(TAG)

.PHONY: shell
shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

.PHONY: run
run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

.PHONY: start
start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

.PHONY: stop
stop:
	docker stop $(NAME)

.PHONY: logs
logs:
	docker logs $(NAME)

.PHONY: clean
clean:
	-docker rm -f $(NAME)

.PHONY: release
release: build push