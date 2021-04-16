FROM debian:buster

RUN apt-get -y update && apt-get -y install nginx



docker pull debian:buster
docker run -p 80:80 -it debian:buster
apt-get -y update && apt-get -y install nginx
service nginx start


ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
