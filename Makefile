name = simurg
registry = pasmod

build:
	docker build -t $(registry)/$(name) $(BUILD_OPTS) .

stop:
	docker rm -f $(name) || true

run: stop
	docker run -it --rm=true -v $(shell pwd):/var/www --link redis:db --name=$(name) $(registry)/$(name) bash -l

start: stop
	docker run -d -v $(shell pwd):/var/www --name=$(name) $(registry)/$(name)

start_redis: stop_redis
	docker run --name redis -v $(shell pwd)/redis:/data -d redis redis-server --appendonly yes

stop_redis:
	docker rm -f redis || true

connect_redis:
	docker run -it --link redis:redis --rm redis redis-cli -h redis -p 6379:6379
