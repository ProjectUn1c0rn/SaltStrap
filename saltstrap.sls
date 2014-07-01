/usr/local/sbin/saltstrap-update:
  file:
    - managed
    - source: salt://saltstrap-update
    - user: root
    - group: root
    - mode: 700
