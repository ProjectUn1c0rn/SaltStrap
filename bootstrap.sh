#!/bin/bash

# if dev mode, just run salt
[[ -n "${DEV_MODE}" ]] && salt-call --local state.highstate && exit 0

# Debian testing needs this :
export BS_PIP_ALLOWED=0

# Set git-repo variable system wide
echo SALTSTRAP_GIT_URL=${SALTSTRAP_GIT_URL} > /etc/environment
echo SALTSTRAP_GIT_BRANCH=${SALTSTRAP_GIT_BRANCH} >> /etc/environment

# Bootstrap salstack, we'll use it masterless :
wget -O - https://bootstrap.saltstack.com  -O -|sh

# Default salt minion config :
cat > /etc/salt/minion <<EOF
#all default
EOF

# If no salt repo in /srv yet, clone it
[ ! -d /srv/salt ] && git clone -b ${SALTSTRAP_GIT_BRANCH} ${SALTSTRAP_GIT_URL} /srv/salt

# Making sure git repo is up to datez
cd /srv/salt
git pull
git submodule init
git submodule update

# Masterless mode, using /srv/salt 
salt-call --local state.highstate
