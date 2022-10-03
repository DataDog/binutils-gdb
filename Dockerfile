FROM debian as build

RUN apt update && apt install -y curl gcc g++ make

ARG VERSION=2.37
ENV srcdir=/usr/local/src/binutils-$VERSION
ENV installdir=/usr/local/

RUN mkdir -p $srcdir && \
    curl -L https://ftp.gnu.org/gnu/binutils/binutils-$VERSION.tar.gz | tar -xz -C$srcdir --strip-components=1

WORKDIR /tmp/build-aarch64-linux-gnu
RUN $srcdir/configure --prefix=$installdir --target=aarch64-linux-gnu --disable-all -enable-strip
RUN make -j8 all
RUN make install

WORKDIR /tmp/build-x86_64-linux-gnu
RUN $srcdir/configure --prefix=$installdir --target=x86_64-linux-gnu --disable-all -enable-strip
RUN make -j8 all
RUN make install

WORKDIR /tmp/build-x86_64-apple-darwin
RUN $srcdir/configure --prefix=$installdir --target=x86_64-apple-darwin --disable-all -enable-strip
RUN make -j8 all
RUN make install

FROM debian:testing-slim
COPY --from=build /usr/local /usr/local