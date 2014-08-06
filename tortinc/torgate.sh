#!/bin/sh

### set variables

# destinations you don't want routed through Tor are 
# gathered from bootstrap export (export SALTSTRAP_NONTOR=192.168.1.0/24)

REBOOT_ME=0
if [ ! -f /etc/torgate.configured ]; then
	#not configured yet, get non-tor nets from env and set :
	REBOOT_ME=1
	touch /etc/torgate.configured
fi	
. /etc/torgate.conf

_non_tor="$_non_tor 224.0.0.251" #allowing mdns avahi only broadcast/respond on vpn

#the UID that Tor runs as (varies from system to system)
_tor_uid=`id -u debian-tor`

#Tor's TransPort
_trans_port="9040"

### flush iptables
iptables -F
iptables -t nat -F

### set iptables *nat
iptables -t nat -A OUTPUT -m owner --uid-owner $_tor_uid -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53

#allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/9 127.128.0.0/10 169.254.0.0/16; do
   iptables -t nat -A OUTPUT -d $_clearnet -j RETURN
done

#redirect all other output to Tor's TransPort
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $_trans_port

### set iptables *filter
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#allow clearnet access for hosts in $_non_tor
for _clearnet in $_non_tor 127.0.0.0/8 169.254.0.0/16; do
   iptables -A OUTPUT -d $_clearnet -j ACCEPT
done

#allow only Tor output
iptables -A OUTPUT -m owner --uid-owner $_tor_uid -j ACCEPT
iptables -A OUTPUT -j REJECT

#fix for leak from : https://lists.torproject.org/pipermail/tor-talk/2014-March/032503.html
iptables -I OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,FIN ACK,FIN -j DROP
iptables -I OUTPUT ! -o lo ! -d 127.0.0.1 ! -s 127.0.0.1 -p tcp -m tcp --tcp-flags ACK,RST ACK,RST -j DROP


[ $REBOOT_ME -eq 1 ] && reboot && sleep 120
exit 0
