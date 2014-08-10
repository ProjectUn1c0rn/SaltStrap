cowsay:
  pkg:
    - latest
fortunes-bofh-excuses:
  pkg:
    - latest
    
https://github.com/ProjectUn1c0rn/Core.git:
  git.latest:
    - rev: master
    - target: /srv/un1c0rn
    
/srv/un1c0rn:
  composer.installed:
    - no_dev: true
    - require:
      - cmd: install-composer
      - git: https://github.com/ProjectUn1c0rn/Core.git
      - file: /etc/un1c0rn.conf.php
/etc/un1c0rn.conf.php:
  file.managed:
    - source: salt://un1c0rn/un1c0rn.conf.php
    - template: jinja
    - mode: 644
    - user: root
    - group: root

php5-curl:
  pkg.latest:
    - require:
      - pkg: php5-cli
php5-mysql:
  pkg.latest:
    - require:
      - pkg: php5-cli
php-pear:
  pkg.latest:
    - require:
      - pkg: php5-cli
libgearman-dev:
  pkg.latest
mongodb-dev:
  pkg.latest
php5-dev:
  pkg.latest
gearman:
  pecl.installed:
    - require:
      - pkg: php-pear     
      - pkg: libgearman-dev
      - pkg: php5-dev
mongo:
  pecl.installed:
    - require:
      - pkg: php-pear
      - pkg: mongodb-dev
      - pkg: php5-dev
/etc/php5/mods-available/gearman.ini:
  file.managed:
    - source: salt://un1c0rn/gearman-php.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pecl: gearman
/etc/php5/mods-available/mongo.ini:
  file.managed:
    - source: salt://un1c0rn/mongo-php.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pecl: mongo

/usr/sbin/php5enmod gearman:
  cmd.run:
    - require:
      - file: /etc/php5/mods-available/gearman.ini
/usr/sbin/php5enmod mongo:
  cmd.run:
    - require:
      - file: /etc/php5/mods-available/mongo.ini


/etc/bash.bashrc:
  file.managed:
    - source: salt://un1c0rn/profile
    - user: root
    - group: root
    - mode: 700
    - require:
      - pkg: cowsay
      - pkg: fortunes-bofh-excuses
supervisor:
  pkg.latest:
    - require:
      - file: /etc/supervisor/conf.d
  service.running:
    - watch:
      - file: /etc/supervisor/conf.d
      - file: /etc/un1c0rn.conf.php
/etc/supervisor/conf.d:
  file.recurse:
    - source: salt://un1c0rn/supervisor.d
    - include_empty: True
