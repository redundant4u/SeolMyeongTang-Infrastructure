FROM golang:1.25-alpine

WORKDIR /app
COPY docker/smt/main .
CMD ["./main"]
