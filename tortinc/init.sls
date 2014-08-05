tor-apt:
  cmd:
    - run
    - name: apt-key adv --keyserver keys.gnupg.net --recv 886DDD89
    - unless: apt-key list | grep -q 886DDD89

/etc/apt/sources.list.d/tor.list:
  file:
    - managed
    - source: salt://tortinc/apt-tor.list
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: tor-apt
tor:
  pkg:
    - latest
  service:
    - running
    - watch:
      - file: /etc/tor/torrc
    - require:
      - service: ntp
      - pkg: tor
      - file: /etc/tor/torrc
      - cmd: tor-apt
/etc/hosts:
  file:
    - managed
    - source: salt://tortinc/hosts
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/tor/torrc
    - template: jinja
update-saltstrap-tor-name:
  cmd.run:
    - name: salt-call --local grains.setval SALTSTRAP_TORNAME $(cat /var/lib/tor/unicorn.endpoint/hostname)&&cp /var/lib/tor/unicorn.endpoint/hostname /etc/hostname 
    - unless: salt-call --local grains.get SALTSTRAP_TORNAME|grep -q onion
    - require:
      - file: /etc/tor/torrc
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

/etc/network/if-pre-up.d/torgate:
  file.managed:
    - source: salt://tortinc/torgate.sh
    - user: root
    - group: root
    - mode: 700
    
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
