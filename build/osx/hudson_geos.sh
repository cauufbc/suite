#!/bin/bash

# Script directory
d=`dirname $0`

# Load versions
source ${d}/hudson_config.sh

function usage() {
  echo "Usage: $0 <setup|build>"
  exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

case "$1" in

  setup)

    rm -rf geos-svn
    svn co ${geos_svn}/${geos_version} geos-svn
    ;;


  build)

    if [ -d geos-svn ]; then
      cd geos-svn
    fi

    ./autogen.sh
    CXX=g++-4.0 CC=gcc-4.0 CXXFLAGS="-O2 -arch i386 -arch ppc -mmacosx-version-min=10.4" CFLAGS="-O2 -arch i386 -arch ppc -mmacosx-version-min=10.4" ./configure --prefix=${buildroot}/geos --disable-dependency-tracking
    make clean
    make all
    if [ $rv -gt 0 ]; then
      echo "GEOS build failed with return value $rv"
      exit 1
    fi

    rm -rf ${buildroot}/geos
    mkdir ${buildroot}/geos
    make install
    cd ${buildroot}/geos
    rm -f ~/Sites/geos-osx.zip
    zip -r9 ~/Sites/geos-osx.zip *
    ;;

  *)
    usage
    ;;

esac

exit 0
    
