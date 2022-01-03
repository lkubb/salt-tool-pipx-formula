{%- from 'tool-pipx/map.jinja' import pipx -%}

{%- for user in pipx.users | rejectattr('xdg', 'sameas', False) %}
pipx data is migrated to XDG_DATA_HOME for user '{{ user.name }}':
  file.rename:
    - name: {{ user.xdg.data }}/pipx
    - source: {{ user.home }}/local/pipx
    - makedirs: true

pipx uses XDG dirs during this salt run:
  environ.setenv:
    - value:
        PIPX_HOME: "{{ user.xdg.data }}/pipx"

  {%- if user.get('persistenv') %}
pipx knows about XDG location for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.persistenv }}
    - text: export PIPX_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pipx"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
