# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}
{%- set install_method = pipx.get("install_method", "pkg") %}

include:
  - {{ sls_config_clean }}


Pipx is removed:
{%- if install_method == "asdf" %}
  pip.removed:
    - name: {{ pipx.lookup.pkg.name }}
    - bin_env: {{ salt["cmd.run_stdout"]("asdf which pip") }}
{%- else %}
  pkg.removed:
    - name: {{ pipx.lookup.pkg.name }}
{%- endif %}
    - require:
      - sls: {{ sls_config_clean }}
