IMAGE=docker.cloudin.com/testing/netserver
TAG=v1.0.0

container: clean
	chmod 777 run.sh
	docker build --no-cache -t $(IMAGE):$(TAG) .

run: container
	docker run --rm --name=netserver $(IMAGE):$(TAG)

clean:
	docker rm -f netserver || true
	docker rmi -f $(IMAGE):$(TAG) || true