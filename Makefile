APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ngana0
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

help:
	@echo "Hello QA Engineer!"
	@echo "Run the command 'make <target OS>' to build your solution"
	@echo "                                                     "
	@echo "Example:                                             "
	@echo "    make arm       # build arm/Linux binary          "
	@echo "    make macos     # build macOS binary              "
	@echo "    make windows   # build Windows binary            "
	@echo "                                                     "
	@echo "Docker targets:                                      "
	@echo "    make image     # build Docker image              "
	@echo "    make push      # push Docker image to the repository"
	@echo "    make clean     # clean env by removing Docker image and kbot"

arm: 
	build TARGETOS=linux TARGETARCH=${TARGETARCH}

macos:
	make build TARGETOS=darwin TARGETARCH=${TARGETARCH}

windows:
	make build TARGETOS=windows TARGETARCH=${TARGETARCH}


format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v 

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/ng-n/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} 

push: 
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf ${APP}
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

