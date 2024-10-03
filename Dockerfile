# from node image
FROM node:18-bullseye

LABEL org.opencontainers.image.authors="kumarsaurabh.singh@maastrichtuniversity.nl"

ARG JBROWSE_VERSION=2.15.4
ARG SAMTOOLS_VERSION=1.21
ARG HTSLIB_VERSION=1.21

# Handle dependencies
USER root
RUN apt-get update && apt-get -y upgrade && apt-get -y install build-essential git zlib1g-dev genometools vim tabix net-tools htop && apt-get clean && echo -n > /var/lib/apt/extended_states

RUN mkdir -p /soft/bin

RUN wget -q https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && tar jxf samtools-${SAMTOOLS_VERSION}.tar.bz2 && cd samtools-${SAMTOOLS_VERSION} && make prefix=/soft/samtools install && cd /soft/bin && ln -s /soft/samtools/bin/* . && cd /soft && rm -rf *tar.bz2

RUN wget -q https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 && tar jxf htslib-${HTSLIB_VERSION}.tar.bz2 && cd htslib-${HTSLIB_VERSION} && make prefix=/soft/htslib install && cd /soft/bin && ln -s /soft/htslib/bin/* . && cd /soft && rm -rf *tar.bz2

# PATH
ENV PATH $PATH:/soft/bin

WORKDIR /

RUN npm install -g @jbrowse/cli \
&& jbrowse --version
RUN jbrowse create jbrowse2

EXPOSE 8080
WORKDIR /jbrowse2
CMD npx serve .
