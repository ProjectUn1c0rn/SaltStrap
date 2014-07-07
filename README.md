#SaltStrap

Bootstrap an instance on bare Debian stable (Ubuntu needs testing) from a git repo and provide update tools

##Requirement

 * Clean debian stable installation
 * Full Internet access (NATed or not)

##Install 

```bash
SALTSTRAP_GIT_URL=https://github.com/ProjectUn1c0rn/SaltStrap
SALTSTRAP_GIT_BRANCH=master
apt-get install ca-certificates -y
wget -O - https://goo.gl/Lz4FLn|bash
```

 * http://goo.gl/Lz4FLn -> Latest bootstrap.sh from Saltstrap

```bash
# Onliner detailed :
# Base repository URL for saltstrap bootstraping :
export SALTSTRAP_GIT_URL=https://github.com/ProjectUn1c0rn/SaltStrap
# Branch :
export SALTSTRAP_GIT_BRANCH=master
# Install basic "trusted" certificates (for goo.gl,github.com ...) :
apt-get install ca-certificates -y
# Get latest bootstrap.sh from SaltStrap and run :
wget -O - https://goo.gl/Lz4FLn|sh
```


##Usage

###saltstrap-update

Update the machine from origin git repo

```bash
 saltstrap-update
```

##Development

Branch this repository and adapt your repo URL in the oneliner install command (SALTSTRAP_GIT_URL and BRANCH)

Edit top.sls and add new states !

You shouldn't need to modify bootstrap.sh , but if you do, don't forget to edit the "wget -O - https://goo.gl/Lz4FLn|bash" part in your README.md

There's a full blown example deploying a Un1c0rn.net minion's at https://github.com/ProjectUn1c0rn/SaltStrap/tree/unicorn-minion


