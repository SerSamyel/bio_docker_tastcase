FROM ubuntu:18.04

USER root

# Install dependencies
RUN apt-get update &&\
    apt-get install -yqq build-essential \
                              apt-utils \
                              zlib1g-dev \
                              autoconf \
                              automake \
                              libtool \
                              pkg-config \
                              libncurses5-dev \
                              libncursesw5-dev \
                              git \
                              wget \
                              gnuplot \
                              make \
                              libbz2-dev \
                              liblzma-dev \
                              libcurl4-openssl-dev

# build libdeflate
WORKDIR /SOFT/
RUN git clone https://github.com/ebiggers/libdeflate.git libdeflate \
    && cd libdeflate \
    && make

#build htslib
WORKDIR /SOFT/
RUN git clone https://github.com/samtools/htslib.git htslib \
    && cd htslib \
    && autoheader \
    && autoconf  \
    && ./configure \
    && make \
    && make install

# build samtools
WORKDIR /SOFT/
RUN git clone https://github.com/samtools/samtools.git samtools \
    && cd samtools \
    && autoheader \
    && autoconf -Wno-syntax \
    && ./configure \
    && make \
    && make install
# build libmaus2
WORKDIR /SOFT/
RUN git clone https://github.com/gt1/libmaus2.git libmaus2 \
    && cd libmaus2 \
    && libtoolize \
    && aclocal \
    && autoreconf -i -f \
    && ./configure \
    && make

# build biobambam2
WORKDIR /SOFT/
RUN git clone https://github.com/gt1/biobambam2.git biobambam2 \
    && cd biobambam2 \
    && autoreconf -i -f \
    && ./configure --with-libmaus2=/SOFT/libmaus2 \
    && make install
