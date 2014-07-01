#SaltStrap

Bootstrap an instance on bare Debian stable (Ubuntu needs testing) from a git repo and provide update tools

##Requirement

 * Clean debian stable installation
 * Full Internet access (NATed or not)

##Install 

```bash
export SALTSTRAP_GIT_URL=https://github.com/ProjectUn1c0rn/SaltStrap&&export SALTSTRAP_GIT_BRANCH=master &&apt-get install ca-certificates -y&&wget -O - https://goo.gl/Lz4FLn|sh
```

 * http://goo.gl/Lz4FLn -> Latest bootstrap.sh from Saltstrap

##Development

Branch this repository and adapt your repo URL in bootstrap.sh


