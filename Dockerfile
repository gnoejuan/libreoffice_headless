FROM ubuntu:bionic
# RUN  echo 'Acquire::http { Proxy "http://192.168.1.148:3142"; };' >> /etc/apt/apt.conf.d/01proxy
RUN apt-get update && apt-get upgrade -y && apt-get install git \
    flex \
    wget \
    libxinerama-dev \
    libgl-dev \
    zip \
    autoconf \
    ccache \
    nasm \
    libffi-dev \
    libmpc-dev \
    libmpfr-dev \
	libgmp-dev \
    libicu-dev \
    libpython3.7-dev \
    fonts-crosextra-caladea \
	fonts-crosextra-carlito \
    fonts-liberation \
    mesa-utils \
    libx11-dev \
    libxext-dev \
    libice-dev \
	libsm-dev \
    libssl-dev \
    libxrender-dev \
    libxslt1-dev \
    gperf \
    libfontconfig1-dev \
    libpng-dev \
	libexpat1-dev \
    gcc \
    flex\
    xsltproc \
    libxml2-utils \
    libcurl4-nss-dev \
    libnss3-dev\
    bison \
    libnspr4-dev -y 
RUN apt-get install build-essential -y
WORKDIR /app
# RUN git config --global url."http://192.168.1.148:3142/".insteadOf https://
RUN git clone --depth=1 git://anongit.freedesktop.org/libreoffice/core .
RUN ccache --max-size 6 G && ccache -s
RUN ./autogen.sh --disable-report-builder --disable-lpsolve --disable-coinmp \
	--enable-mergelibs --disable-odk --disable-gtk --disable-cairo-canvas \
	--disable-dbus --disable-sdremote --disable-sdremote-bluetooth --disable-gio --disable-randr \
	--disable-gstreamer-1-0 --disable-cve-tests --disable-cups --disable-extension-update \
	--disable-postgresql-sdbc --disable-lotuswordpro --disable-firebird-sdbc --disable-scripting-beanshell \
	--disable-scripting-javascript --disable-largefile --without-helppack-integration \
	--without-system-dicts --without-java --disable-gtk3 --disable-dconf --disable-gstreamer-0-10 \
	--disable-firebird-sdbc --without-fonts --without-junit --with-theme="no" --disable-evolution2 \
	--disable-avahi --without-myspell-dicts --with-galleries="no" \
	--disable-kde4 --with-system-expat --with-system-libxml --with-system-nss \
	--disable-introspection --without-krb5 --disable-python --disable-pch \
	--with-system-openssl --with-system-curl --disable-ooenv --disable-dependency-tracking
RUN make
RUN strip -s ./instdir/**/*; exit 0
RUN rm -rf ./instdir/share/gallery \
	./instdir/share/config/images_*.zip \
	./instdir/readmes \
	./instdir/CREDITS.fodt \
	./instdir/LICENSE* \
	./instdir/NOTICE
RUN tar -zcvf lo.tar.gz instdir