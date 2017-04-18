FROM debian:stretch
MAINTAINER ccondit@randomcoder.org

ADD assets /assets

RUN \
	echo "deb http://ftp.us.debian.org/debian stretch main non-free contrib" > /etc/apt/sources.list && \
	echo "deb http://security.debian.org/ stretch/updates main contrib non-free" >> /etc/apt/sources.list && \
	echo "deb-src http://ftp.us.debian.org/debian sid main contrib non-free" >> /etc/apt/sources.list && \
	apt-get update && \
	apt-get -y install gnupg2 && \
	apt-key add /assets/bintray-public.key.asc && \
	apt-get update && \
	apt-get -y dist-upgrade && \
	apt-get -y install dpkg-dev build-essential devscripts lintian patch patchutils && \
	rm -rf /var/cache/apt && \
	mkdir -p /build /packages

RUN \
	apt-get update && \
	apt-get -y install dh-python python-all-dev python3-all-dev python-all-dbg python3-all-dbg

ADD patches /patches

RUN \
	apt-get update && \
	apt-get -y install python-stdeb && \
	cd /build && \
	curl -O \
		'https://pypi.python.org/packages/43/a6/f0f9db2ac157a4b39efe0920bf1b2d986a4e2d2c0968614070ac0d24c4c8/certbot-external-auth-0.0.8.tar.gz' && \
	py2dsc \
		--suite stretch-backports-randomcoder \
		--maintainer 'Craig Condit <ccondit@randomcoder.org>' \
		certbot-external-auth-0.0.8.tar.gz && \
	cd deb_dist && \
	cd certbot-external-auth-* && \
	export DEBEMAIL=ccondit@randomcoder.org && \
	export DEBFULLNAME="Craig Condit" && \
	dch -b \
		-l "+local" \
		--distribution stretch-backports-randomcoder \
		--force-distribution --noquery \
		'Build for Debian Jessie.' && \
	patch -p1 < /patches/allow-noninteractive.patch && \
	dch -b \
		--distribution stretch-backports-randomcoder \
		--force-distribution --noquery \
		--increment \
		'Allow non-interactive usage.' && \
	debian/rules binary && \
	cd .. && \
	cp -f *+local*.deb /packages/

