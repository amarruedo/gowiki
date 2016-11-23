FROM golang:1.7.3

RUN go get github.com/tebeka/go2xunit

COPY . /go/src/github.com/amarruedo/gowiki

WORKDIR /go/src/github.com/amarruedo/gowiki
