.PHONY: up down log db clean_db redis clean_redis 

db:
	docker run -p5432:5432 --name=dev_db_assignment -d -e POSTGRES_USER=dev_user -e POSTGRES_PASSWORD=secret -e POSTGRES_DB=dev_db_assignment postgres:13

clean_db:
	docker rm -f dev_db_assignment

redis:
	docker run -p6379:6379 --name=dev_db_assignment_redis -d redis:alpine3.19

clean_redis:
	docker rm -f dev_db_assignment_redis

log:
	docker logs -f db_assignment_backend

down: clean_db clean_redis

rebuild: down dev

dev: db redis