FROM library/openjdk:8-jre-alpine

ARG toolVersion

RUN \
    apk add --no-cache bash python && \
    apk add --no-cache -t .required_apks wget make g++ pcre-dev && \
    wget --no-check-certificate -O /tmp/cppcheck.tar.gz https://github.com/danmar/cppcheck/archive/"$toolVersion".tar.gz && \
    tar -zxf /tmp/cppcheck.tar.gz -C /tmp && \
    cd /tmp/cppcheck-$toolVersion && \
    make install -j$(nproc) CFGDIR=/cfg MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes \
        CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function --static" && \
    apk del .required_apks && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/bin/cppcheck"]
CMD []
