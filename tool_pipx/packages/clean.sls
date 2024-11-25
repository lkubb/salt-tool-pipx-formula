# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}


{%- for user in pipx.users | selectattr("pipx.packages", "defined") %}
{%-   for package in user.pipx.packages %}

Pipx package '{{ package }}' is removed for user '{{ user.name }}':
  pipx.absent:
    - name: {{ package }}
    - user: {{ user.name }}
{%-   endfor %}
{%- endfor %}
