IMAGE=docker.cloudin.com/testing/bandwidth-server
TAG=v1.0.0

container: clean
	docker build --no-cache -t $(IMAGE):$(TAG) .

run: container
	docker run --rm --name=bandwidth-server $(IMAGE):$(TAG)

clean:
	docker rmi -f $(IMAGE):$(TAG) || true