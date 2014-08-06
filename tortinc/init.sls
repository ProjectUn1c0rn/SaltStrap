
#Adding officials tor repository key
sdi-apt:
  cmd:
    - run
    - name: apt-key adv --keyserver keys.gnupg.net --recv 3BD8041F
    - unless: apt-key list | grep -q 3BD8041F

/etc/apt/sources.list.d/sdinet.list:
  file:
    - managed
    - source: salt://tortinc/apt-sdi.list
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: sdi-apt

tor-apt:
  cmd:
    - run
    - name: apt-key adv --keyserver keys.gnupg.net --recv 886DDD89
    - unless: apt-key list | grep -q 886DDD89

#and repo source :
/etc/apt/sources.list.d/tor.list:
  file:
    - managed
    - source: salt://tortinc/apt-tor.list
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: tor-apt
      
# installing tor package
tor:
  pkg:
    - latest
  service:
    - running
    - watch:
    # make sure we restart tor if we update the config
      - file: /etc/tor/torrc
    - require:
      # tor is picky with time drift, and so should you ;)
      - service: ntp
      - pkg: tor
      - file: /etc/tor/torrc
      - cmd: tor-apt

# set hostname to torname :  
/etc/hosts:
  file:
    - managed
    - source: salt://tortinc/hosts
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/tor/torrc
      - cmd: update-saltstrap-tor-name
    - template: jinja
/etc/hostname:
  file:
    - managed
    - source: salt://tortinc/hostname
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/tor/torrc
      - cmd: update-saltstrap-tor-name
    - template: jinja
/etc/nsswitch.conf:
  file:
    - managed
    - source: salt://tortinc/nsswitch.conf
    - require:
      - pkg: libnss-mdns

# update local grains to match our new tor name
update-saltstrap-tor-name:
  cmd.run:
    - name: salt-call --local grains.setval SALTSTRAP_TORNAME $(cat /var/lib/tor/unicorn.endpoint/hostname)
    - unless: salt-call --local grains.get SALTSTRAP_TORNAME|grep -q onion
    - require:
      - file: /etc/tor/torrc
# ntp install :
ntp:
  pkg:
    - latest
  service:
    - running
    - watch:
      - file: /etc/ntp/ntp.conf
    - require:
      - pkg: ntp
      - file: /etc/ntp/ntp.conf

/etc/ntp/ntp.conf:
  file.managed:
    - source: salt://tortinc/ntp.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    
/etc/tor/torrc:
  file.managed:
    - source: salt://tortinc/torrc
    - user: debian-tor
    - group: debian-tor
    - mode: 600
    - makedirs: true

/etc/dhcp/dhclient.conf:
  file.managed:
    - source: salt://tortinc/dhclient.conf
    - user: root
    - group: root
    - mode: 644

#make sure we're running jailed everytime a new interface comes up :
/etc/network/if-pre-up.d/torgate:
  file.managed:
    - source: salt://tortinc/torgate.sh
    - user: root
    - group: root
    - mode: 700
#run jailing for the first time and reboot :
runtorgate:
  cmd.run:
    - name: /etc/network/if-pre-up.d/torgate 
    - require:
      - file: /etc/network/if-pre-up.d/torgate
      - file: /etc/torgate.conf
      - service: tor

/etc/torgate.conf:
  file.managed:
    - source: salt://tortinc/torgate.conf
    - user: root
    - group: root
    - mode: 600
    - template: jinja

/etc/resolv.conf:
  file.managed:
    - source: salt://tortinc/resolv.conf
    - user: root
    - group: root
    - mode: 644
tinc:
  pkg:
    - latest
  service:
    - running
    - require:
      - cmd: update-saltstrap-tor-name
    - watch:
      - file: /etc/tinc
/etc/tinc:
  file.recurse:
    - source: salt://tortinc/tinc
    - include_empty: True
    - template: jinja
/etc/tinc/un1c0rn/tinc-up:
  file.managed:
    - mode: 744
    - require: 
      - file: /etc/tinc
/etc/tinc/un1c0rn/tinc-down:
  file.managed:
    - mode: 744
    - require: 
      - file: /etc/tinc

#create a new key pair 
create-tinc-keypair:
  cmd.run:
    - name: echo |tinc -n un1c0rn generate-rsa-keys&&tinc -n un1c0rn generate-ecdsa-keys&&echo Address=$(hostname -s).onion >> /etc/tinc/un1c0rn/hosts/$(hostname -s)
    - unless: cat /etc/tinc/un1c0rn/rsa_key.priv|grep -q PRIVATE
    - require:
      - file: /etc/tinc

avahi-daemon:
  pkg:
    - latest
  service:
    - running
    - require:
      - cmd: update-saltstrap-tor-name
    - watch:
      - file: /etc/avahi/avahi-daemon.conf

avahi-autoipd:
  pkg:
    - latest

libnss-mdns:
  pkg:
    - latest
    
/etc/avahi/avahi-daemon.conf:
  file:
    - managed
    - source: salt://tortinc/avahi/avahi-daemon.conf
    - template: jinja
    - require:
      - cmd: update-saltstrap-tor-name
lighttpd:
  pkg:
    - latest
  service:
    - running
    - require:
      - cmd: create-tinc-keypair
    - watch: 
      - file: /etc/lighttpd/lighttpd.conf
/etc/lighttpd/lighttpd.conf:
  file:
    - managed
    - source: salt://tortinc/lighttpd/lighttpd.conf
    - template: jinja
    - require:
      - pkg: lighttpd
cp /etc/tinc/un1c0rn/hosts/$(hostname) /var/www/pubkey:
  cmd:
    - run
    - unless: [ -f /var/www/pubkey ]
