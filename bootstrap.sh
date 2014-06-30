#!/bin/bash
# as root :
# apt-get install ca-certificates -y
# wget -O - https://raw.githubusercontent.com/ProjectUn1c0rn/SaltStrap/master/bootstrap.sh|sh
# salt-minion install :
export BS_PIP_ALLOWED=0
wget -O - https://bootstrap.saltstack.com  -O -|sh
cat > /etc/salt/minion <<EOF
fileserver_backend:
  - git
gitfs_remotes:
  - https://github.com/ProjectUn1c0rn/SaltStrap.git
EOF
salt-call --local state.highstate
