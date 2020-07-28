include:
    - pkg-python-pip

pyvmomi:
  pip.installed:
    - require:
      - pkg: python-pip