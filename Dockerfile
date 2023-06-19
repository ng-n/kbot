#FROM golang:1.19 as builder
FROM quay.io/projectquay/golang:1.20 as builder

WORKDIR /go/src/app
COPY . .
#RUN go get
ARG TARGETOS
ARG TARGETARCH
RUN make build TARGETOS=$TARGETOS TARGETARCH=$TARGETARCH


FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT [ "./kbot", "start" ]
