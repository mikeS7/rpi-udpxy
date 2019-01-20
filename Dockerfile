FROM balenalib/armv7hf-alpine:3.8 as builder

RUN [ "cross-build-start" ]
RUN apk add --no-cache curl make gcc musl-dev && \
    curl -O -J http://www.udpxy.com/download/udpxy/udpxy-src.tar.gz && \
    tar -xzvf udpxy-src.tar.gz && \
    cd udpxy-1.0.23-12 && make && make install
RUN [ "cross-build-end" ]

FROM arm32v6/alpine:3.8 as runner
COPY --from=builder /usr/local/bin/udpxy /usr/local/bin/

EXPOSE 4022
ENTRYPOINT [ "/usr/local/bin/udpxy" ]
CMD [ "-T", "-p", "4022" ]