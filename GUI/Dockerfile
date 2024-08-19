# Dockerfile
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-transport-https ca-certificates gnupg && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 40976EAF437D05B5 C0B21F32 && \
    apt-get clean && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
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
    python3.9 \
    python3-pip \
    python3.9-venv \
    software-properties-common \
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
    libxcb-xinerama0 \
    util-linux && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]

RUN pip3 install setuptools msgpack matplotlib numpy scipy

RUN git clone https://github.com/vnegnev/marcos_client.git /opt/marcos_client
RUN git clone https://github.com/vnegnev/marcos_server.git /opt/marcos_server
RUN git clone https://github.com/vnegnev/marcos_extras.git /opt/marcos_extras
RUN git clone https://github.com/josalggui/MaRGE.git /opt/marge
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

WORKDIR /opt/marcos_client
COPY local_config.py.example /opt/marcos_client/local_config.py

WORKDIR /opt/marge
COPY hw_config.py.copy /opt/marge/configs/hw_config.py
COPY sys_config.py.copy /opt/marge/configs/sys_config.py
COPY units.py.copy /opt/marge/configs/units.py
RUN pwd
RUN ls
RUN python3.9 -m venv myenv
RUN source myenv/bin/activate && pip install --upgrade pip
RUN pip3 install -r requirements.txt


ENTRYPOINT ["python", "main.py"]


