# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}

include:
  - {{ tplroot }}.package


{%- for user in pipx.users | selectattr('rchook', 'defined') | selectattr('rchook') %}

Pipx completions are loaded on shell startup for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.rchook) }}
    - pattern: {{ 'eval "$(register-python-argcomplete pipx)"' | regex_escape }}$
    - repl: ''
{%- endfor %}
