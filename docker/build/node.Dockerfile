ARG ARCH="amd64"

FROM ${ARCH}/centos:7
ENV GOLANG_VERSION 1.12
ARG ARCH="amd64"
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum update -y && \
    yum install -y autoconf wget awscli git gnupg2 nfs-utils python36 sqlite3 boost-devel expect jq libtool gcc-c++ libstdc++-devel libstdc++-static rpmdevtools createrepo rpm-sign bzip2 which ShellCheck
WORKDIR /root
RUN wget https://dl.google.com/go/go${GOLANG_VERSION}.linux-${ARCH%v*}.tar.gz \
    && tar -xvf go${GOLANG_VERSION}.linux-${ARCH%v*}.tar.gz && \
    mv go /usr/local
ENV GOROOT=/usr/local/go \
    GOPATH=$HOME/go
RUN mkdir -p $GOPATH/src/github.com/algorand
COPY . $GOPATH/src/github.com/algorand/go-algorand
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH \
    BRANCH=${BRANCH} \
    CHANNEL=${CHANNEL} \
    BUILDCHANNEL=${BUILDCHANNEL} \
    DEFAULTNETWORK=${DEFAULTNETWORK} \
    FULLVERSION=${FULLVERSION} \
    PKG_ROOT=${PKG_ROOT}
WORKDIR $GOPATH/src/github.com/algorand/go-algorand
RUN make ci-deps && make clean && make ci-build
RUN goal network create -n private -d ~/private-network -r ~/private-network --template /go/src/github.com/algorand/go-algorand//test/testdata/nettemplates/TwoNodesOneOnline.json
ENTRYPOINT [ "docker/build/entrypoint.sh" ]
