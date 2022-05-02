FROM golang:1.18-bullseye as builder

RUN apt update && apt upgrade -y
RUN useradd -m app
WORKDIR /home/app
COPY . .

RUN chown -R app /home/app
USER app
RUN go mod tidy
RUN go build -o out/server

FROM debian:bullseye-slim

COPY --from=builder /home/app/out/server /usr/local/bin/

RUN apt update && apt upgrade -y
RUN chmod 755 /usr/local/bin/server

RUN useradd -m app

USER app
WORKDIR /home/app

EXPOSE 8080
CMD ["/usr/local/bin/server"]
