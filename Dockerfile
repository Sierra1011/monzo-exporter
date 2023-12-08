ARG golang_version="1.20"
FROM golang:$golang_version AS build

WORKDIR /go/src/github.com/Sierra1011/monzo-exporter

COPY $PWD/go.mod go.mod
COPY $PWD/go.sum go.sum

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go mod download

COPY $PWD/*.go ./

RUN go build -o /bin/monzo-exporter

FROM alpine AS run

RUN apk update && apk upgrade

COPY --from=build /bin/monzo-exporter /bin/monzo-exporter

ENTRYPOINT ["/bin/monzo-exporter"]
