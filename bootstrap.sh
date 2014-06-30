#!/bin/bash
# as root :
# apt-get install ca-certificates -y
# wget -O - https://raw.githubusercontent.com/ProjectUn1c0rn/SaltStrap/master/bootstrap.sh|sh
# salt-minion install :
export BS_PIP_ALLOWED=0
wget -O - https://bootstrap.saltstack.com  -O -|sh
cat > /etc/salt/minion <<EOF
#all default
EOF
[ ! -d /srv/salt ] && git clone https://github.com/ProjectUn1c0rn/SaltStrap.git /srv/salt
cd /srv/salt
git submodule init
salt-call --local state.highstate
shutdown -r 10 "Now rebooting to finalize tor isolation\!"
