#!/bin/bash

# Debian testing needs this :
export BS_PIP_ALLOWED=0

# Bootstrap salstack, we'll use it masterless :
wget -O - https://bootstrap.saltstack.com  -O -|sh

# Default salt minion config :
cat > /etc/salt/minion <<EOF
#all default
EOF

# If no salt repo in /srv yet, clone it
[ ! -d /srv/salt ] && git clone https://github.com/ProjectUn1c0rn/SaltStrap.git /srv/salt

# Making sure git repo is up to date
cd /srv/salt
git pull
git submodule init
git submodule update

# Masterless mode, using /srv/salt 
salt-call --local state.highstate
