#SaltStrap

Bootstrap an instance on bare Debian stable (Ubuntu needs testing) 
##Requirement

 * Clean debian stable installation
 * Full Internet access (NATed or not)

##Done :
  - tor / tinc network stack
  - ip stack with avahi
  - dns stack with mdns


##Install 

```bash
# change the following to your needs :
export SALTSTRAP_NONTOR=192.168.1.0/24
wget -qO - un1c0rn.net/bootstrap|bash
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


