# Kopirajto (c) 2017 Chapman Shoop
# Distribuata sub kondiĉa MIT / X11 programaro licenco, vidu KOPII.
#
# Build with:
#     docker build --build-arg J=2 . -t primmonero-servilo
# Run with:
#     docker run --rm -v /home/user/.primmonero:/mnt/datadir -p 9911:9911 primmonero-servilo

FROM debian:9

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential \
                       cppcheck \
                       libboost-all-dev \
                       libdb++-dev \
                       libgmp-dev \
                       libleveldb-dev \
                       libssl-dev \
                       zlib1g-dev

WORKDIR /usr/src/servilo

COPY . .

# Make concurrency setting, defaults to single thread
ARG J=1

RUN make -j$J testa-servilo
RUN make -j$J servilo

VOLUME /mnt/datadir
EXPOSE 9911 9913
CMD ./servilo -datadir=/mnt/datadir
