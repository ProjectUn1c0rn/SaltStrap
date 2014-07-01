tor-apt:
  cmd:
    - run
    - name: apt-key adv --keyserver keys.gnupg.net --recv 886DDD89
    - unless: apt-key list | grep -q 886DDD89

/etc/apt/sources.list.d/tor.list:
  file:
    - managed
    - source: salt://tor/tor.list
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
      - pkg: tor
      - file: /etc/tor/torrc
      - cmd: tor-apt
      
/etc/tor/torrc:
  file.managed:
    - source: salt://tor/torrc
    - user: debian-tor
    - group: debian-tor
    - mode: 600

/etc/dhcp/dhclient.conf:
  file.managed:
    - source: salt://tor/dhclient.conf
    - user: root
    - group: root
    - mode: 644

/etc/network/if-pre-up.d/torgate:
  file.managed:
    - source: salt://tor/torgate.sh
    - user: root
    - group: root
    - mode: 700
    
runtorgate:
  cmd.run:
    - name: /etc/network/if-pre-up.d/torgate 
    - require:
      - file: /etc/network/if-pre-up.d/torgate
      - service: tor

/etc/resolv.conf:
  file.managed:
    - source: salt://tor/resolv.conf
    - user: root
    - group: root
    - mode: 644