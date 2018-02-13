-include .env

CESANTA_VER ?= 1.3

BASE_IMAGE_TAG = $(CESANTA_VER)
REPO = wodby/registry-auth
NAME = registry-auth-$(CESANTA_VER)

ifeq ($(TAG),)
    TAG ?= $(CESANTA_VER)
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
	cd ./test/8 && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./test/7 && IMAGE=$(REPO):$(TAG) ./run.sh

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