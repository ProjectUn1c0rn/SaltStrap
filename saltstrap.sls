/usr/local/sbin/saltstrap-update:
  file:
    - managed
    - source: salt://saltstrap-update
    - user: root
    - group: root
    - mode: 700
we-only-need-salt-framework:
  pkg.removed:
    - name: salt-minion
/etc/rc.local:
  file.managed:
    - source: salt://saltstrap-boot
    - user: root
    - group: root
    - mode: 744
