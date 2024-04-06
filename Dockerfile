FROM ubuntu

# install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update -y
RUN apt install bsdmainutils git wget build-essential libssl-dev libboost-chrono1.74-dev libboost-filesystem1.74-dev libboost-program-options1.74-dev libboost-system1.74-dev libboost-thread1.74-dev libboost-test1.74-dev qtbase5-dev qttools5-dev bison libexpat1-dev libdbus-1-dev libfontconfig-dev libfreetype-dev libice-dev libsm-dev libx11-dev libxau-dev libxext-dev libevent-dev libxcb1-dev libxkbcommon-dev libminiupnpc-dev libprotobuf-dev libqrencode-dev xcb-proto x11proto-xext-dev x11proto-dev xtrans-dev zlib1g-dev libczmq-dev autoconf automake libtool protobuf-compiler -y

# set up workspace
WORKDIR /
RUN mkdir /app
RUN mkdir /app/src
WORKDIR /app/src

# clone source
RUN git clone https://github.com/RavenProject/Ravencoin
WORKDIR /app/src/Ravencoin
RUN git checkout develop

# set up database and config
RUN contrib/install_db4.sh ../
RUN ./autogen.sh
ENV BDB_PREFIX=/app/src/db4
RUN ./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include" --prefix=/usr/local

# build and install
RUN make -j12
RUN make install

CMD ["/usr/local/bin/raven-qt"]
