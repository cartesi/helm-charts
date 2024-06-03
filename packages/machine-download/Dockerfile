FROM golang:1.20-bookworm as builder
RUN go install github.com/ipfs/ipget@latest

FROM debian:bookworm-20230725
COPY --from=builder /go/bin/ipget /usr/local/bin/
