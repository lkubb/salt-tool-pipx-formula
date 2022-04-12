# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}


Pipx is installed:
  pkg.installed:
    - name: {{ pipx.lookup.pkg.name }}
    - version: {{ pipx.get('version') or 'latest' }}
    {#- do not specify alternative return value to be able to unset default version #}

Pipx setup is completed:
  test.nop:
    - name: Hooray, Pipx setup has finished.
    - require:
      - pkg: {{ pipx.lookup.pkg.name }}
