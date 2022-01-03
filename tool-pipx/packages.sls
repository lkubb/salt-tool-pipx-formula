{%- from 'tool-pipx/map.jinja' import pipx -%}

include:
  - .package

{%- for user in pipx.users | selectattr('pipx.packages', 'defined') %}
  {%- for package in user.pipx.packages %}
pipx package '{{ package }}' is installed for user '{{ user.name }}':
  pipx.installed:
    - name: {{ package }}
    - user: {{ user.name }}
  {%- endfor %}
{%- endfor %}
