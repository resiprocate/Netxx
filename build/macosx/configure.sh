#!/bin/sh
TLS=""

if [ -r /usr/include/openssl/ssl.h ]; then
    TLS="--enable-tls --openssl-prefix=/usr"
elif [ -r /sw/include/openssl/ssl.h ]; then
    TLS="--enable-tls --openssl-prefix=/sw"
fi

./configure.pl --disable-shared --disable-ipv6 --disable-streambuf $TLS $*
