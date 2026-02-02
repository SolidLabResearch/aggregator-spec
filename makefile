IMAGE ?= maartyman/bikeshed-image:v1.0.0
SPEC ?= spec.bs
DIST ?= dist
PORT ?= 59754

.PHONY: build dev

build:
	docker run --rm -v "$(PWD)":/work $(IMAGE) $(SPEC) $(DIST)

dev:
	docker run --rm -v "$(PWD)":/work -e DEV=1 -e PORT=$(PORT) -p $(PORT):$(PORT) $(IMAGE) $(SPEC) $(DIST)
