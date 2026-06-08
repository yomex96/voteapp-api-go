# Stage 1: Build the Go binary securely
FROM golang:1.22-alpine AS build
WORKDIR /app

# Copy dependency files first to leverage caching
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Compile the binary with optimization flags for container production
# CGO_ENABLED=0 ensures the binary is completely static and doesn't rely on OS libraries
RUN CGO_ENABLED=0 GOOS=linux go build -o api main.go

# Stage 2: Final lightweight and secure runtime image
FROM alpine:latest
WORKDIR /app

# Install security certificates (critical if your API calls external HTTPS endpoints)
RUN apk --no-cache add ca-certificates

# Copy only the compiled binary from Stage 1
COPY --from=build /app/api .

# Expose the API port
EXPOSE 8080

# Run the binary
CMD ["./api"]


