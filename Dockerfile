FROM handcraftedbits/nginx-unit:1.0.1
MAINTAINER HandcraftedBits <opensource@handcraftedbits.com>

COPY data /

RUN apk update && \
  apk add bash git go libc-dev && \

  mkdir -p /opt/go-import-redirector && \
  cd /opt && \
  GOPATH=/opt/gopath go get rsc.io/go-import-redirector && \
  mv gopath/bin/go-import-redirector go-import-redirector/go-import-redirector && \
  rm -rf gopath && \

  apk del git go libc-dev

EXPOSE 80

CMD ["/bin/bash", "/opt/container/script/run-go-import-redirector.sh"]
