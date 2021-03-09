SHELL ?= /bin/bash
ARGS = $(filter-out $@,$(MAKECMDGOALS))

.SILENT: ;
.ONESHELL: ;
.NOTPARALLEL: ;
.EXPORT_ALL_VARIABLES: ;
Makefile: ;

.PHONY: up
up: network
	docker-compose up -d

.PHONY: mysql
mysql:
	docker-compose exec mysql mysql ${ARGS}

.PHONY: mysql-dump
mysql-dump:
	docker-compose exec mysql mysqldump -u root --all-databases > ${ARGS}

.PHONY: redis
redis:
	docker-compose exec redis redis-cli ${ARGS}

.PHONY: stop
stop:
	docker-compose stop ${ARGS}

.PHONY: redis-m
redis-m:
	docker-compose exec redis redis-cli MONITOR

.PHONY: redis-clear-1
redis-clear-1:
	docker-compose exec redis redis-cli -n 1 flushdb


.PHONY: network
network:
	docker network create telegram-bots-network 2> /dev/null | true


.PHONY: help
help: .title
	echo ''
	echo 'Available targets:'
	echo '  help:       Show this help and exit'
	echo '  up:         Create and start application in detached mode (in the background)'
	echo '  stop:       Stop container {name}'
	echo '  redis:      Run redis-cli {args}'
	echo '  mysql:      Run mysql {args}'
	echo '  mysql-dump: Create mysqldump {path/to/dump}'
	echo '  redis-m:    Run redis monitor'
	echo '  network:    Create external docker network'
	echo ''

%:
	@: