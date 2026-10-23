# syntax=docker/dockerfile:1

# Go version for the build stage; `make docker-build` passes the one from your local toolchain.
ARG GO_VERSION=1

# ---- Build stage: full Go toolchain, discarded after the build ----
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS build
ARG TARGETOS
ARG TARGETARCH
ARG VERSION=dev
WORKDIR /src

# Dependencies first: this layer is cached until go.mod/go.sum change.
COPY go.* ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH \
    go build -trimpath -ldflags "-s -w -X main.version=${VERSION}" -o /out/demo-app .

# ---- Runtime stage: no shell, no package manager, non-root user ----
FROM gcr.io/distroless/static-debian13:nonroot
COPY --from=build /out/demo-app /demo-app
USER 65532:65532
EXPOSE 8080
ENTRYPOINT ["/demo-app"]
