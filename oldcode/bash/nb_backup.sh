#!/bin/sh

cd ~/backup

#  dir=`mktemp temp.XXXXXX` || exit 1
mkdir temp

#  tar cvzf $tarball .
scp -pr morris@ninjabunny.org:~/ninjabunny-www temp

rm ninjabunny.`date  --date='3 days ago' '+%Y-%m-%d'`.tgz

tar cvzf ninjabunny.`date '+%Y-%m-%d'`.tgz temp
rm -rf temp

