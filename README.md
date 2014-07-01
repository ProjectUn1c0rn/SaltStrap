#SaltStrap - Isolated Tor Instance

Bootstrap an Isolated Tor instance on bare Debian stable (Ubuntu needs testing) from a git repo and provide update tools

##Requirement

 * Clean debian stable installation
 * Full Internet access (NATed or not)

##Install 


```bash
export SALTSTRAP_GIT_URL=https://github.com/ProjectUn1c0rn/SaltStrap&&export SALTSTRAP_GIT_BRANCH=instance-tor &&apt-get install ca-certificates -y&&wget -O - https://goo.gl/Lz4FLn|sh
```
Machine will reboot to complete isolation and all trafic will now go trough tor's network !
Exceptions : 192.168.1.0/24

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

You shouldn't need to modify bootstrap.sh , but if you do, don't forget to edit the "wget -O - https://goo.gl/Lz4FLn|sh" part in your README.md



