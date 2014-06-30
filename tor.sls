tor:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: tor
      
