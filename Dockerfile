# syntax=docker/dockerfile:1

##
## Build
##
FROM golang:1.18-buster AS build

WORKDIR /app

COPY go.mod ./
# COPY go.sum ./
RUN go mod download

COPY ./ ./

RUN go build github.com/KazanExpress/tf-toolbox/cmd/cleanplan
RUN go build github.com/KazanExpress/tf-toolbox/cmd/findroot
RUN go build github.com/KazanExpress/tf-toolbox/cmd/unlock

##
## Deploy
##
FROM alpine:3.13

WORKDIR /app

COPY --from=build /app/findroot /app/findroot
COPY --from=build /app/cleanplan /app/cleanplan
COPY --from=build /app/unlock /app/unlock


ENV PATH="/app:$PATH"

ENTRYPOINT ["/app/unlock"]
