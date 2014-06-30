#!/bin/bash
# use "wget https://raw.githubusercontent.com/ProjectUn1c0rn/SaltStrap/master/bootstrap.sh|sudo sh"
# salt-minion install :
wget -O - https://bootstrap.saltstack.com | sudo sh
cat > /etc/salt/minion <<EOF
fileserver_backend:
  - git
gitfs_remotes:
  - https://github.com/ProjectUn1c0rn/SaltStrap.git
EOF
salt-call --local state.highstate
