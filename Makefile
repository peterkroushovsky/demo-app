VERSION    ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
GO_VERSION ?= $(shell go env GOVERSION | sed -E 's/go([0-9]+\.[0-9]+).*/\1/')
IMAGE      ?= ghcr.io/peterkroushovsky/demo-app
LDFLAGS    := -s -w -X main.version=$(VERSION)

.PHONY: run test build fmt vet clean docker-build docker-run

run:
	go run -ldflags "$(LDFLAGS)" .

test:
	go test -race -cover ./...

build:
	CGO_ENABLED=0 go build -ldflags "$(LDFLAGS)" -o bin/demo-app .

fmt:
	gofmt -w .

vet:
	go vet ./...

clean:
	rm -rf bin/

docker-build:
	docker build \
		--build-arg GO_VERSION=$(GO_VERSION) \
		--build-arg VERSION=$(VERSION) \
		-t $(IMAGE):$(VERSION) -t $(IMAGE):local .

docker-run:
	docker run --rm -p 8080:8080 --name demo-app $(IMAGE):local
