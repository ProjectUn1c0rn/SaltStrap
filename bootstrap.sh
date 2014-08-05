#!/bin/bash

#setting salt repo :
wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
echo "deb http://debian.saltstack.com/debian jessie-saltstack main" > /etc/apt/sources.list.d/saltstack.list
apt-get update
apt-get install python-msgpack -q -y #allow failling on debian stable
apt-get install git python-zmq salt-common -q -y

#clone the git repo :
[ ! -d /srv/salt ] && git clone -b ${SALTSTRAP_GIT_BRANCH} ${SALTSTRAP_GIT_URL} /srv/salt

# Making sure git repo is up to date
cd /srv/salt
git pull
git submodule init
git submodule update

# Setting minion grains from SALTSTRAP ENV 
env|grep ^SALTSTRAP_|while read line; do
  salt-call --local grains.setval "$(echo $line|cut -d\= -f1)" "$(echo $line|cut -d\= -f2)"
done

# Masterless mode, using /srv/salt 
salt-call --local state.highstate
