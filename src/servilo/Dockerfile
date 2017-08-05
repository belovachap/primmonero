# Build the docker image with:
#     docker build -t primmonera-servilo
# Run with
#     docker run --rm -v /home/user/.primmonero:/mnt/datadir -p 9911:9911 primmonera-servilo

FROM debian:8

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential \
                       libboost-all-dev \
                       libdb++-dev \
                       libgmp-dev \
                       libjson-spirit-dev \
                       libleveldb-dev \
                       libssl-dev

WORKDIR /usr/src/servilo

COPY . .

RUN make testo
RUN make

VOLUME /mnt/datadir
EXPOSE 9911 9913
CMD ./primmonera-servilo -datadir=/mnt/datadir
