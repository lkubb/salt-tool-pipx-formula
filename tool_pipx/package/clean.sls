# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}
{%- set install_method = pipx.get("install_method", "pkg") %}

include:
  - {{ sls_config_clean }}

{%- if install_method == "asdf" %}
{%-   for user in pipx.users %}

Pipx is removed for user '{{ user.name }}':
  pip.removed:
    - name: {{ pipx.lookup.pkg.name }}
    - bin_env: {{ salt["cmd.run_stdout"]("asdf which pip") }}
    - require:
      - sls: {{ sls_config_clean }}
{%-   endfor %}
{%- else %}

Pipx is removed:
  pkg.removed:
    - name: {{ pipx.lookup.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}
{%- endif %}
