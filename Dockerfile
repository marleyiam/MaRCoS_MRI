# Dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    vim \
    psmisc \
    libgoogle-perftools-dev \
    help2man \
    autoconf \
    flex \
    bison \
    ccache \
    numactl \
    perl \
    perl-doc \
    python3 \
    python3-pip \
    ssh \
    build-essential \
    cmake \
    net-tools \
    telnet \
    make \
    cmake \
    g++ \
    libfl2 \
    libfl-dev \
    zlibc \
    zlib1g \
    zlib1g-dev \
    util-linux

RUN pip3 install msgpack matplotlib numpy scipy


RUN git clone https://github.com/marcos-mri/marcos_server /opt/marcos_server
RUN git clone https://github.com/marcos-mri/marcos_client /opt/marcos_client
RUN git clone https://github.com/vnegnev/marga.git /opt/marga
RUN git clone https://github.com/marcos-mri/marcos_extras /opt/marcos_extras

RUN git clone https://github.com/verilator/verilator /opt/verilator
WORKDIR /opt/verilator
RUN git pull
RUN git tag
RUN git checkout master #stable
RUN autoconf
RUN export VERILATOR_ROOT=`pwd`
RUN ./configure
RUN make -j `nproc`
RUN make install

RUN fallocate -l 516KiB /tmp/marcos_server_mem

WORKDIR /opt/marga
RUN mkdir build &&  cd /opt/marga/build && cmake ../src && make -j4
##RUN fallocate -l 516KiB /tmp/marcos_server_mem
RUN export marga_sim_path=/opt/marga/build/
RUN export marga_sim=/opt/marga/build/marga_sim
RUN ./marga_sim csv &


WORKDIR /opt/marcos_client
COPY local_config.py.example /opt/marcos_client/local_config.py

#WORKDIR /opt/marga
#RUN mkdir build && cd build && cmake ../src/

#WORKDIR /opt/marcos_client
#RUN pythons test_marga_model.py

# Build the server
WORKDIR /opt/marcos_server
RUN mkdir build && cd build && cmake ../src && make -j4


COPY start_server.sh /opt/start_server.sh
RUN chmod +x /opt/start_server.sh

ENTRYPOINT ["/opt/start_server.sh"]


