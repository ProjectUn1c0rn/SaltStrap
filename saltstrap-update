#!/bin/bash
export PATH=$PATH:/usr/local/bin
cd /srv/salt
git pull&&git submodule update
# change every setting we could have set by env :
env|grep ^SALTSTRAP_|while read line; do
  echo Setting option $(echo $line|cut -d\= -f1)
  salt-call --local grains.setval "$(echo $line|cut -d\= -f1)" "$(echo $line|cut -d\= -f2)"
done
echo Updating from repo 
salt-call --local state.highstate
