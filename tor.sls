tor:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: tor
      - file: /etc/tor/torrc
      - tor-apt
      
/etc/tor/torrc:
  file.managed:
    - source: salt://torrc
    - user: debian-tor
    - group: debian-tor
    - mode: 600

/etc/network/if-pre-up.d/torgate:
  file.managed:
    - source: salt://torgate.sh
    - user: root
    - group: root
    - mode: 700
    
