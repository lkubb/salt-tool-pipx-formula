Pipx is installed:
  pkg.installed:
    - name: pipx

Pipx setup is completed:
  test.nop:
    - name: Pipx setup has finished, this state exists for technical reasons.
    - require:
      - pkg: pipx
