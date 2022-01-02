{%- from 'tool-pipx/map.jinja' import pipx %}

{%- if pipx.users | selectattr('dotconfig') %}
include:
  - .configsync
{%- endif %}

pipx is updated to latest version:
{%- if grains['kernel'] == 'Darwin' %}
  pkg.installed: # assumes homebrew as package manager. homebrew always installs the latest version, mac_brew_pkg does not support upgrading a single package
{%- else %}
  pkg.latest:
{%- endif %}
    - name: pipx
