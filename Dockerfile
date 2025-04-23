FROM golang:1.23.4 AS builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod tidy

COPY . .

RUN go build -o tracker .

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/tracker /app/
COPY --from=builder /app/tracker.db /app/

EXPOSE 8080

CMD ["./tracker"]
