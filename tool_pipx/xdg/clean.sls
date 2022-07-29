# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}


{%- for user in pipx.users | rejectattr('xdg', 'sameas', false) %}

{%-   set user_default_conf = user.home | path_join(pipx.lookup.paths.confdir) %}
{%-   set user_xdg_confdir = user.xdg.config | path_join(pipx.lookup.paths.xdg_dirname) %}
{%-   set user_xdg_conffile = user_xdg_confdir | path_join(pipx.lookup.paths.xdg_conffile) %}

Pipx configuration is cluttering $HOME/.local for user '{{ user.name }}':
  file.rename:
    - name: {{ user_default_conf }}
    - source: {{ user_xdg_confdir }}

Pipx does not have its data folder in XDG_DATA_HOME for user '{{ user.name }}':
  file.absent:
    - name: {{ user_xdg_confdir }}
    - require:
      - Pipx configuration is cluttering $HOME/.local for user '{{ user.name }}'

Pipx does not use XDG dirs during this salt run:
  environ.setenv:
    - value:
        PIPX_HOME: false
    - false_unsets: true

{%-   if user.get('persistenv') %}

Pipx is ignorant about XDG location for user '{{ user.name }}':
  file.replace:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: ^{{ 'export PIPX_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/' ~ pipx.lookup.paths.xdg_dirname
                 ~ '"' | regex_escape }}$
    - repl: ''
    - ignore_if_missing: true
{%-   endif %}
{%- endfor %}
