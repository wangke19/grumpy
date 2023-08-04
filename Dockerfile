# build stage
FROM golang:1.20 AS build-env
RUN mkdir -p /go/src/github.com/wangke19/grumpy
WORKDIR /go/src/github.com/wangke19/grumpy
COPY  . .
RUN useradd -u 10001 webhook
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o grumpywebhook

FROM scratch
COPY --from=build-env /go/src/github.com/wangke19/grumpy/grumpywebhook .
COPY --from=build-env /etc/passwd /etc/passwd
USER webhook
ENTRYPOINT ["/grumpywebhook"]
