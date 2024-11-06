# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}

include:
  - {{ tplroot }}.package


{%- for user in pipx.users | rejectattr("xdg", "sameas", false) %}

{%-   set user_default_data = user.home | path_join(pipx.lookup.paths.confdir) %}
{%-   set user_xdg_datadir = user.xdg.data | path_join(pipx.lookup.paths.xdg_dirname) %}

# workaround for file.rename not supporting user/group/mode for makedirs
XDG_DATA_HOME exists for Pipx for user '{{ user.name }}':
  file.directory:
    - name: {{ user.xdg.data }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0755'
    - makedirs: true
    - onlyif:
      - test -e '{{ user_default_data }}'

Existing Pipx data is migrated for user '{{ user.name }}':
  file.rename:
    - name: {{ user_xdg_datadir }}
    - source: {{ user_default_data }}
    - require:
      - XDG_DATA_HOME exists for Pipx for user '{{ user.name }}'
    - require_in:
      - Pipx setup is completed

Pipx has its data dir in XDG_DATA_HOME for user '{{ user.name }}':
  file.directory:
    - name: {{ user_xdg_datadir }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - makedirs: true
    - mode: '0755'
    - require:
      - Existing Pipx data is migrated for user '{{ user.name }}'
    - require_in:
      - Pipx setup is completed

# @FIXME
# This actually does not make sense and might be harmful:
# Each file is executed for all users, thus this breaks
# when more than one is defined!
Pipx uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        PIPX_HOME: {{ user_xdg_datadir }}
    - require_in:
      - Pipx setup is completed

{%-   if user.get("persistenv") %}

persistenv file for Pipx exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.persistenv) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

Pipx knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.persistenv) }}
    - text: export PIPX_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/{{ pipx.lookup.paths.xdg_dirname }}"
    - require:
      - persistenv file for Pipx exists for user '{{ user.name }}'
    - require_in:
      - Pipx setup is completed
{%-   endif %}
{%- endfor %}
