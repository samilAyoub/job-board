# Build stage
FROM golang:1.21 AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o bin/server .

# Final stage
FROM alpine:latest  
RUN apk --no-cache add ca-certificates
WORKDIR /app
COPY --from=builder /app/bin/server bin/server
CMD ["./bin/server"]