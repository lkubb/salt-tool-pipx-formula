# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}
{%- set install_method = pipx.get("install_method", "pkg") %}
{#- do not specify alternative return value to be able to unset default version #}
{%- set version = pipx.get("version") or "latest" %}

{%- if install_method == "asdf" %}

include:
  - tool_asdf
{%- endif %}

Pipx is installed:
{%- if install_method == "asdf" %}
{%-   set pip_version = version if version != "latest" else "" %}
  pip.installed:
    - name: {{ pipx.lookup.pkg.name ~ pip_version }}
    - bin_env: __slot__:salt:cmd.run_stdout("asdf which pip")
    - upgrade: true
    - require:
      - sls: tool_asdf.system.configure
{%- else %}
  pkg.installed:
    - name: {{ pipx.lookup.pkg.name }}
    - version: {{ pipx.get('version') or 'latest' }}
{%- endif %}

Pipx setup is completed:
  test.nop:
    - name: Hooray, Pipx setup has finished.
    - require:
      - Pipx is installed
