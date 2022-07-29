# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}

include:
  - {{ tplroot }}.package.install


{%- for user in pipx.users | selectattr('pipx.packages', 'defined') %}
  {%- for package in user.pipx.packages %}
pipx package '{{ package }}' is installed for user '{{ user.name }}':
  pipx.installed:
    - name: {{ package }}
    - user: {{ user.name }}
    - require:
      - Pipx setup is completed
  {%- endfor %}
{%- endfor %}
