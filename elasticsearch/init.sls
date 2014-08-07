elastic-apt:
  cmd:
    - run
    - name: apt-key adv --keyserver keys.gnupg.net --recv D88E42B4
    - unless: apt-key list | grep -q D88E42B4

/etc/apt/sources.list.d/elasticsearch.list:
  file:
    - managed
    - source: salt://elasticsearch/elasticsearch.list
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: elastic-apt
openjdk-7-jre:
  pkg:
    - latest
elasticsearch:
  pkg:
    - latest
    - require: 
      - cmd: elastic-apt
      - pkg: openjdk-7-jre
  service:
    - running
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
    - require:
      - pkg: elasticsearch
      - file: /etc/elasticsearch/elasticsearch.yml
      
/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: salt://elasticsearch/elasticsearch.yml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
