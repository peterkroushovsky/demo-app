VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
LDFLAGS := -s -w -X main.version=$(VERSION)

.PHONY: run test build fmt vet clean

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
