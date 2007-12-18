#!/bin/sh

if [ $# -gt 0 ]; then
    OUTPUT=$1
else
    OUTPUT="gen.jam"
fi

SUFOBJ=`$NETXX_JAM -sSUFFIX_TEST=yes | head -1`

# start the output file
NOW=`date`
echo "# Created: $NOW" > $OUTPUT

# compile some tests
printf "Building some test programs ..."

printf '.'
$NETXX_JAM -sCOMPILE_TEST=yes inet6$SUFOBJ 2>&1 > /dev/null
if [ ! -r inet6$SUFOBJ ]; then
    echo 'C++FLAGS += "-DNETXX_NO_INET6" ;' >> $OUTPUT
fi

printf '.'
$NETXX_JAM -sCOMPILE_TEST=yes inet_ntop$SUFOBJ 2>&1 > /dev/null
if [ ! -r inet_ntop$SUFOBJ ]; then
    echo 'C++FLAGS  += "-DNETXX_NO_NTOP" ;' >> $OUTPUT
    echo 'SRC_FILES += "inet_ntop.cxx" ;' >> $OUTPUT
fi

printf '.'
$NETXX_JAM -sCOMPILE_TEST=yes inet_pton$SUFOBJ 2>&1 > /dev/null
if [ ! -r inet_pton$SUFOBJ ]; then
    echo 'C++FLAGS  += "NETXX_NO_PTON" ;' >> $OUTPUT
    echo 'SRC_FILES += "inet_pton.cxx" ;' >> $OUTPUT
fi

# now figure out what resolver to use
printf '.'
$NETXX_JAM -sCOMPILE_TEST=yes getaddrinfo$SUFOBJ 2>&1 > /dev/null
if [ -r getaddrinfo$SUFOBJ ]; then
    echo 'SRC_FILES += "resolve_getaddrinfo.cxx" ;' >> $OUTPUT
else
    echo 'SRC_FILES += "resolve_gethostbyname.cxx" ;' >> $OUTPUT
    echo 'SRC_FILES += "resolve_getservbyname.cxx" ;' >> $OUTPUT
fi

# link test
printf '.'
$NETXX_JAM -sSOCKET_TEST=yes socket 2>&1 > /dev/null
if [ ! -r socket ]; then
    printf '.'
    $NETXX_JAM -sSOCKET_TEST=yes -sWITH_SOCKET_LIBS=yes socket 2>&1 > /dev/null
    if [ ! -r socket ]; then
	echo
	echo "===> FAILED to build socket test. Sorry."
	exit 
    fi

    NEED_SOCKET_LIBS=yes
fi

if [ "x$NEED_SOCKET_LIBS" = "xyes" ]; then
    OPENSSL_FLAGS="-sWITH_SOCKET_LIBS=yes"
fi

printf '.'
$NETXX_JAM -sOPENSSL_TEST=yes $OPENSSL_FLAGS openssl 2>&1 > /dev/null
if [ -r openssl ]; then
    HAS_OPENSSL=yes
fi

if [ "x$HAS_OPENSSL" = "xyes" ]; then
    echo 'LINKLIBS  += "-lssl -lcrypto" ;' >> $OUTPUT
    echo 'HAVE_OPENSSL = "yes" ;' >> $OUTPUT
fi

if [ "x$NEED_SOCKET_LIBS" = "xyes" ]; then
    echo 'LINKLIBS += "-lsocket -lnsl" ;' >> $OUTPUT
fi

# clean up
printf '.'
$NETXX_JAM -sCOMPILE_TEST=yes -sSOCKET_TEST=yes -sOPENSSL_TEST=yes clean 2>&1 > /dev/null
echo
