# Build the docker image with:
# 	docker build -t primmonera-servilo
# Run with
#	docker run --rm -v /home/user/.primmonero:/mnt/datadir -p 9911:9911 primmonera-servilo

FROM debian:8

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential
RUN apt-get install -y libboost-all-dev
RUN apt-get install -y libssl-dev
RUN apt-get install -y libdb++-dev
RUN apt-get install -y libleveldb-dev
RUN apt-get install -y libgmp-dev
RUN apt-get install -y libjson-spirit-dev

WORKDIR /usr/src/servilo

COPY . .

RUN make

VOLUME /mnt/datadir
EXPOSE 9911
CMD ./primmonera-servilo -datadir=/mnt/datadir
