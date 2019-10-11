# This is the dockerfile we use to run the project locally as well as
# compile the code for a slim production image
FROM golang:1.12-alpine as builder

ENV CGO_ENABLED=0\
    GOOS=linux\
    GOPATH=/go

WORKDIR /go/src/github.com/operator-framework

RUN apk update \
    && apk add git mercurial make \
    && rm -rf /var/cache/apk/*

# Add rest of source code
# This will download the git repository and not install it
RUN go get -d github.com/operator-framework/operator-sdk 2>/dev/null ; exit 0

WORKDIR /go/src/github.com/operator-framework/operator-sdk

RUN ls -l \
    && git checkout master \
    && make tidy \
    && make ci-build

FROM golang:1.12-alpine

ENV CGO_ENABLED=0\
    GOOS=linux

WORKDIR /workspace

RUN apk --no-cache update && \
      apk --no-cache add bash ca-certificates git mercurial make && \
      rm -rf /var/cache/apk/*

COPY --from=builder /go/src/github.com/operator-framework/operator-sdk/build/operator-sdk /usr/local/bin/

VOLUME ["/workspace"]

ENTRYPOINT ["operator-sdk"]
