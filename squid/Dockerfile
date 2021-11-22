FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ="UTC"
ARG SQUID_VERSION="5.2"
ARG CA_SUBJECT="/C=ES/ST=Barcelona/L=Barcelona/O=Marfeel Solutions, S.L./OU=SysOps Team/CN=squid.mrf.io/emailAddress=ops@marfeel.com"

RUN apt-get update && \
    apt-get -y install \
        build-essential \
        curl \
        git \
        libssl-dev \
        libxml2-dev \
        libltdl-dev \
        openssl \
        pkg-config \
        vim

RUN apt-get -y install \
    autoconf automake autopoint autotools-dev bsdmainutils cdbs comerr-dev debhelper dh-apparmor \
    dh-autoreconf dh-strip-nondeterminism dh-translations distro-info-data dwz ed gettext gettext-base groff-base \
    icu-devtools intltool intltool-debian jq krb5-multidev libarchive-zip-perl libbsd0 libcap-dev libcppunit-1.15-0 \
    libcppunit-dev libcroco3 libtdb-dev libdb-dev libdb5.3-dev libdebhelper-perl libecap3-dev libelf1 \
    libencode-locale-perl libevent-2.1-7 libexpat1-dev libfile-listing-perl \
    libfile-stripnondeterminism-perl libfile-which-perl libgmp-dev libgmpxx4ldbl libgnutls-dane0 libgnutls-openssl27 \
    libgnutls28-dev libgnutlsxx28 libgssrpc4 libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl \
    libhttp-cookies-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libicu-dev libidn2-dev libio-html-perl \
    libio-socket-ssl-perl libjq1 libkadm5clnt-mit11 libkadm5srv-mit11 libkdb5-9 libkrb5-dev libldap2-dev libltdl-dev \
    liblwp-mediatypes-perl liblwp-protocol-https-perl libnet-http-perl libnet-ssleay-perl libnetfilter-conntrack-dev \
    libnfnetlink-dev libonig5 libp11-kit-dev libpam0g-dev libpipeline1 libpython3-stdlib libsasl2-dev libsigsegv2 \
    libsub-override-perl libtasn1-6-dev libtimedate-perl libtool libtry-tiny-perl libuchardet0 libunbound8 liburi-perl \
    libwww-perl libwww-robotrules-perl libxml-parser-perl libxml2-dev lsb-release m4 man-db nettle-dev perl-openssl-defaults \
    po-debconf python3 python3-minimal python3-pkg-resources python3-scour python3-six python3.8 python3.8-minimal scour

RUN mkdir -p /tmp/squid && \
    curl -Ls http://www.squid-cache.org/Versions/v5/squid-${SQUID_VERSION}.tar.gz | tar -zx -C /tmp/squid --strip-components=1 && \
    mkdir -p /tmp/squid/src/icmp/tests && \
    mkdir -p /tmp/squid/tools/squidclient/tests && \
    mkdir -p /tmp/squid/tools/tests && \
    cd /tmp/squid && \
    ./configure \
      --build=x86_64-linux-gnu \
      --datadir=${prefix}/share/squid \
      --disable-arch-native \
      --disable-dependency-tracking \
      --disable-maintainer-mode \
      --disable-silent-rules \
      --disable-translation \
      --enable-async-io=8 \
      --enable-auth-basic=DB,fake,getpwnam,LDAP,NCSA,NIS,PAM,POP3,RADIUS,SASL,SMB \
      --enable-auth-digest=file,LDAP \
      --enable-auth-negotiate=kerberos,wrapper \
      --enable-auth-ntlm=fake,SMB_LM \
      --enable-build-info='Ubuntu linux' \
      --enable-cache-digests \
      --enable-delay-pools \
      --enable-ecap \
      --enable-esi \
      --enable-eui \
      --enable-external-acl-helpers=file_userip,kerberos_ldap_group,LDAP_group,session,SQL_session,time_quota,unix_group,wbinfo_group \
      --enable-follow-x-forwarded-for \
      --enable-icap-client \
      --enable-icmp \
      --enable-inline \
      --enable-linux-netfilter \
      --enable-removal-policies=lru,heap \
      --enable-security-cert-validators=fake \
      --enable-ssl-crtd \
      --enable-storeid-rewrite-helpers=file \
      --enable-storeio=ufs,aufs,diskd,rock \
      --enable-url-rewrite-helpers=fake \
      --enable-zph-qos \
      --includedir=${prefix}/include \
      --infodir=${prefix}/share/info \
      --libexecdir=${prefix}/lib/squid \
      --localstatedir=/var \
      --mandir=${prefix}/share/man \
      --prefix=/usr \
      --srcdir=. \
      --sysconfdir=/etc/squid \
      --with-build-environment=default \
      --with-default-user=proxy \
      --with-filedescriptors=65536 \
      --with-gnutls \
      --with-large-files \
      --with-logdir=/var/log/squid \
      --with-openssl \
      --with-pidfile=/var/run/squid.pid \
      --with-swapdir=/var/spool/squid && \
    make -j8 && \
    make install

RUN mkdir -p /etc/squid/ssl_cert && \
    openssl req \
      -new \
      -newkey rsa:2048 \
      -sha256 \
      -days 36500 \
      -nodes \
      -x509 \
      -extensions v3_ca \
      -keyout /etc/squid/ssl_cert/myCA.pem \
      -out /etc/squid/ssl_cert/myCA.pem \
      -subj "${CA_SUBJECT}" && \
    openssl x509 \
      -in /etc/squid/ssl_cert/myCA.pem \
      -outform DER \
      -out /etc/squid/ssl_cert/maCA.der

RUN /usr/lib/squid/security_file_certgen -c -s /var/lib/ssl_db -M 4MB && \
    chown proxy:proxy -R /var/lib/ssl_db

RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.old

ADD squid.conf /etc/squid/squid.conf

RUN mkdir -p /var/spool/squid/cache /var/log/squid && \
    chown -R proxy:proxy /var/spool/squid && \
    chown -R proxy:proxy /var/log/squid && \
    chown -R proxy:proxy /usr/lib/squid && \
    /usr/sbin/squid -N -f /etc/squid/squid.conf -z


EXPOSE 3128/tcp
ENTRYPOINT ["/usr/sbin/squid"]
CMD ["-f", "/etc/squid/squid.conf", "-NYCd1"]
