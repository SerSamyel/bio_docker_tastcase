FROM ubuntu:18.04

USER root

# Install dependencies
RUN apt-get update &&\
    apt-get install -y build-essential \
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


WORKDIR /SOFT/

# build libdeflate
RUN git clone https://github.com/ebiggers/libdeflate.git libdeflate \
    && cd libdeflate \
    && make \
    && cd ..

#build htslib

RUN git clone https://github.com/samtools/htslib.git htslib \
    && cd htslib \
    && autoheader \
    && autoconf  \
    && ./configure \
    && make \
    && make install \
    && cd ..

# build samtools
RUN git clone https://github.com/samtools/samtools.git samtools \
    && cd samtools \
    && autoheader \
    && autoconf -Wno-syntax \
    && ./configure \
    && make \
    && make install \
    && cd ..

# build libmaus2
RUN git clone https://github.com/gt1/libmaus2.git libmaus2 \
    && cd libmaus2 \
    && libtoolize \
    && aclocal \
    && autoreconf -i -f \
    && ./configure \
    && make \
    && make install \
    && cd ..

# build biobambam2
RUN git clone https://github.com/gt1/biobambam2.git biobambam2 \
    && cd biobambam2 \
    && autoreconf -i -f \
    && ./configure \
    && make install \
    && cd ..
