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
	apt-get -y install python-stdeb python3-setuptools && \
	cd /build && \
	curl -O \
                'https://files.pythonhosted.org/packages/6e/85/6bb20dfb49f2cdb86988c37bc886c39b9a06419694a5ca2a600c3fe463d6/certbot-external-auth-0.1.0.tar.gz' && \
	py2dsc \
                --with-python3=True --with-python2=False \
		--suite stretch-backports-randomcoder \
		--maintainer 'Craig Condit <ccondit@randomcoder.org>' \
		certbot-external-auth-0.1.0.tar.gz && \
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

