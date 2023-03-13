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

{%- if install_method == "asdf" %}
{%-   set pip_version = version if version != "latest" else "" %}
{%-   for user in pipx.users %}

Pipx is installed for user '{{ user.name }}':
  pip.installed:
    - name: {{ pipx.lookup.pkg.name ~ pip_version }}
    - bin_env: __slot__:salt:cmd.run_stdout("asdf which pip", runas='{{ user.name }}')
    - upgrade: true
    - require:
      - sls: tool_asdf.system.configure
    - require_in:
      - Pipx setup is completed

asdf is reshimmed on pipx install for user '{{ user.name }}':
  cmd.run:
    - name: asdf reshim
    - runas: {{ user.name }}
    - onchanges:
      - Pipx is installed for user '{{ user.name }}'
    - require_in:
      - Pipx setup is completed
{%-   endfor %}
{%- else %}

Pipx is installed:
  pkg.installed:
    - name: {{ pipx.lookup.pkg.name }}
    - version: {{ pipx.get('version') or 'latest' }}
    - require_in:
      - Pipx setup is completed
{%- endif %}

Pipx setup is completed:
  test.nop:
    - name: Hooray, Pipx setup has finished.
