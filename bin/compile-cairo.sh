#!/usr/bin/env bash
# bin/compile <build-dir> <cache-dir>

set -e # fail fast

# parse params
BUILD_DIR=$1
CACHE_DIR=$2

# config
S3_BUCKET="rumble-vulcan"

function vendor_binary() {
  binary="$1"
  path="$2"
  include="$3"

  echo " Fetching $binary"
  echo $path
  mkdir -p $path
  package="https://s3.amazonaws.com/$S3_BUCKET/$binary"
  curl $package -s -o - | tar xz -C $path -f -

  echo " Exporting $binary build and include paths"

  export CPPPATH="$path/$include:$CPPPATH"
  export CPATH="$path/$include:$CPATH"
  export LIBRARY_PATH="$path/lib:$LIBRARY_PATH"
  export PKG_CONFIG_PATH="$path/lib/pkgconfig:$PKG_CONFIG_PATH"
  export CFLAGS="-I$path/$include:$CFLAGS"
}

echo "-----> Vendoring binaries"
vendor_binary "cairo-1.12.8.tgz" "$1/vendor/cairo-1.12.8" "include"
vendor_binary "pixman-0.28.0.tgz" "$1/vendor/pixman-0.28.0" "include"
