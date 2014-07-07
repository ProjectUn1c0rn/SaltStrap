#!/bin/bash

# if dev mode, just run salt
[[ -n "${DEV_MODE}" ]] && salt-call --local state.highstate && exit 0

# Debian testing needs this :
export BS_PIP_ALLOWED=0

# Bootstrap salstack, we'll use it masterless :
wget -O - https://bootstrap.saltstack.com  -O -|sh

# Default salt minion config :
cat > /etc/salt/minion <<EOF
#all default
EOF

## try to update and exit again if salt wasn't installed in dev mode 
[[ -n "${DEV_MODE}" ]] && salt-call --local state.highstate && exit 0

## You still there ?, die !
[[ -n "${DEV_MODE}" ]] && echo Salt is not configured correctly \!&& exit 1

# If no salt repo in /srv yet, clone it
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
