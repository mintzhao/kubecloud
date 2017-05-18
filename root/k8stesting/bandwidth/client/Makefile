IMAGE=docker.cloudin.com/testing/bandwidth-client
TAG=v1.0.0

container: clean
	chmod 777 run.sh
	docker build --no-cache -t $(IMAGE):$(TAG) .

run: container
	docker run --rm --link=bandwidth-server --env SERVER=bandwidth-server $(IMAGE):$(TAG)

clean:
	docker rmi -f $(IMAGE):$(TAG) || true