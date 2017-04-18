FROM debian:stretch
MAINTAINER ccondit@randomcoder.org

ADD assets /assets

RUN \
	echo "deb http://ftp.us.debian.org/debian stretch main non-free contrib" > /etc/apt/sources.list && \
	echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb-src http://ftp.us.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y install gnupg2 && \
	apt-key add /assets/bintray-public.key.asc && \
	apt-get -y dist-upgrade && \
	apt-get -y install apt-transport-https && \
	echo "deb https://dl.bintray.com/insideo/stretch-backports-randomcoder randomcoder main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get dist-upgrade && \
	apt-get -y install build-essential devscripts lintian patch patchutils && \
	rm -rf /var/cache/apt && \
	mkdir -p /build /packages

ADD patches /patches

RUN \
	cd /build && \
	apt-get update && \
	apt-get -y build-dep cyrus-sasl2 && \
	apt-get -y source cyrus-sasl2 && \
	rm -rf /var/cache/apt && \
	cd cyrus-* && \
	export DEBEMAIL=ccondit@randomcoder.org DEBFULLNAME="Craig Condit" && \
	dch -b \
		-l "+local" \
		--distribution stretch-backports-randomcoder \
		--force-distribution --noquery \
		'Build for Debian Stretch.' && \
	patch -p1 < /patches/cyrus-sasl2-2.1.27-checkpw.patch && \
	dch -b \
		--distribution stretch-backports-randomcoder \
		--force-distribution --noquery \
		--increment \
		'Allow crypted passwords.' && \ 
	debian/rules binary && \
	cd /build && \
	cp -f *+local*.deb /packages/ && \
	rm -f /packages/*-dbgsym*.deb

