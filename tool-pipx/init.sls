{%- from 'tool-pipx/map.jinja' import pipx %}

include:
  - .package
{%- if pipx.users | rejectattr('xdg', 'sameas', False) %}
  - .xdg
{%- endif %}
{%- if pipx.users | selectattr('rchook', 'defined') %}
  - .completions
{%- endif %}
{%- if pipx.users | selectattr('pipx.packages', 'defined') %}
  - .packages
{%- endif %}
