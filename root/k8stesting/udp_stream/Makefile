NAME=netperf_udp_stream
IMAGE=docker.cloudin.com/testing/$(NAME)
TAG=v1.0.0

container: clean
	chmod 777 run.sh
	docker build --no-cache -t $(IMAGE):$(TAG) .

run: container
	docker run --rm --name=$(NAME) --link=netserver --env SERVER=netserver $(IMAGE):$(TAG)

clean:
	docker rm -f $(NAME) || true
	docker rmi -f $(IMAGE):$(TAG) || true