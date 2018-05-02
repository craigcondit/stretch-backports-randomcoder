FROM debian:stretch
MAINTAINER ccondit@randomcoder.org

ADD assets /assets

RUN \
	echo "deb http://ftp.us.debian.org/debian stretch main non-free contrib" > /etc/apt/sources.list && \
	echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb-src http://ftp.us.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb-src http://ftp.us.debian.org/debian buster main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb http://httpredir.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list && \
	echo "deb-src http://httpredir.debian.org/debian/ stretch-backports main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y install gnupg2 && \
	apt-key add /assets/bintray-public.key.asc && \
	apt-get -y dist-upgrade && \
	apt-get -y install apt-transport-https && \
	echo "deb https://dl.bintray.com/insideo/stretch-backports-randomcoder randomcoder main" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get -y install build-essential devscripts lintian patch patchutils && \
	rm -rf /var/cache/apt && \
	mkdir -p /build /packages

RUN \
	cd /build && \
	apt-get update && \
	apt-get -y source openjdk-10 && \
	apt-get -y build-dep -t stretch openjdk-8 && \
	apt-get -y install -t stretch-backports openjdk-9-jdk && \
	apt-get -y install -t stretch-backports debhelper && \
	rm -rf /var/cache/apt

RUN \
	cd /build/openjdk-10-* && \
	export DEBEMAIL=ccondit@randomcoder.org DEBFULLNAME="Craig Condit" && \
	dch -b \
		-l "+local" \
		--distribution stretch-backports-randomcoder \
		--force-distribution --noquery \
		'Build for Debian Stretch.' && \
	sed -i 's/fail-missing/list-missing/g' debian/rules && \
	debian/rules binary && \
	cd /build && \
	cp -f *+local*.deb /packages/ && \
	rm -f /packages/*-dbgsym*.deb

