
#Adding officials tor repository key

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
# update local grains to match our new tor name
update-saltstrap-tor-name:
  cmd.run:
    - name: salt-call --local grains.setval SALTSTRAP_TORNAME $(cat /var/lib/tor/unicorn.endpoint/hostname)&&cp /var/lib/tor/unicorn.endpoint/hostname /etc/hostname 
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
/etc/tinc:
  file.recurse:
    - source: salt://tortinc/tinc
    - include_empty: True
    - template: jinja
