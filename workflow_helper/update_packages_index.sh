#!/bin/sh
set -e

rm -rf Packages Packages.bz2
dpkg-scanpackages -m . >Packages
bzip2 -k -z Packages

apt-ftparchive release . > Release
