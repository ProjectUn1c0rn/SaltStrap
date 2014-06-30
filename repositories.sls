tor-apt:
  cmd:
    - run
    - name: apt-key adv --keyserver keys.gnupg.net --recv 886DDD89
    - unless: apt-key list | grep -q 0E27C0A6

/etc/apt/sources.list.d/tor.list:
  file:
    - managed
    - source: salt://tor.list
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: saltstack-apt
