# Stage 1: Build C program
FROM gcc:latest AS c-builder

WORKDIR /app

COPY . /app

RUN gcc -o my_program main.c

# Stage 2: Build Go application
FROM golang:1.10 AS go-builder

WORKDIR /go/src/app

COPY . .

RUN go get -v -u github.com/hyperledger/fabric-sdk-go
RUN go get -v -u github.com/stretchr/testify/tree/master/assert

# For BDD
RUN go get github.com/DATA-DOG/godog/cmd/godog

RUN mkdir -p $GOPATH/src/gitlab.com/TheNeonProject/mychaincode
RUN cp -r ./mychaincode/* $GOPATH/src/gitlab.com/TheNeonProject/mychaincode

RUN apt-get update && apt-get install -y libltdl-dev
RUN mkdir -p $GOPATH/src/github.com/hyperledger
RUN git clone -b v1.2.0 https://github.com/hyperledger/fabric.git $GOPATH/src/github.com/hyperledger/fabric

WORKDIR $GOPATH/src/gitlab.com/TheNeonProject/mychaincode

# Stage 3: Final image
FROM ubuntu:latest

COPY --from=c-builder /app/my_program /app/my_program

COPY --from=go-builder /go/src/app /go/src/app

RUN apt-get update \
    && apt-get install -y libltdl-dev

WORKDIR /go/src/app/mychaincode

CMD ["go", "test", "-v", "."]
