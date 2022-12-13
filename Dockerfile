FROM golang:1.19 AS build
WORKDIR /go/src/github.com/zricethezav/gitleaks
COPY . .
RUN CGO_ENABLED=0 go build -o bin/gitleaks

FROM alpine:3.16
RUN adduser -D gitleaks && \
    apk add --no-cache bash git openssh-client
COPY --from=build /go/src/github.com/zricethezav/gitleaks/bin/* /usr/bin/
USER gitleaks

RUN git config --global --add safe.directory '*'

ENTRYPOINT ["gitleaks"]
