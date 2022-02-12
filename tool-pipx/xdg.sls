{%- from 'tool-pipx/map.jinja' import pipx -%}

include:
  - .package

{%- for user in pipx.users | rejectattr('xdg', 'sameas', False) %}
pipx data is migrated to XDG_DATA_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.data }}/pipx
    - source: {{ user.home }}/local/pipx
    - makedirs: true
    - require_in:
      - Pipx setup is completed

pipx uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        PIPX_HOME: "{{ user.xdg.data }}/pipx"
    - require_in:
      - Pipx setup is completed

  {%- if user.get('persistenv') %}

persistenv file for pipx for user '{{ user.name }}' exists:
  file.managed:
    - name: {{ user.home }}/{{ user.persistenv }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

pipx knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export PIPX_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pipx"
    - require:
      - persistenv file for pipx for user '{{ user.name }}' exists
    - require_in:
      - Pipx setup is completed
  {%- endif %}
{%- endfor %}
