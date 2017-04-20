CURRENT_DIRECTORY := $(shell pwd)

build:
	@docker build --tag=espressodev/nginx-drupal:xdebug $(CURRENT_DIRECTORY)

build-no-cache:
	@docker build --no-cache --tag=espressodev/nginx-drupal:xdebug $(CURRENT_DIRECTORY)


.PHONY: build

