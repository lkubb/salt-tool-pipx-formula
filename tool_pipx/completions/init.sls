{#-
    Install Pipx completions into user's rchook file.

    Mind that for ``zsh``, the position of the line loading
    the completions matters. It needs to be placed before
    ``autoload -U bashcompinit && bashcompinit``, but after
    ``compinit``.
-#}


{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as pipx with context %}

include:
  - {{ tplroot }}.package


{%- for user in pipx.users | selectattr('rchook', 'defined') %}

rchook file for Pipx exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home | path_join(user.rchook) }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

Pipx completions are loaded on shell startup for user '{{ user.name }}':
  file.append:
    - name: {{ user.home | path_join(user.rchook) }}
    - text: eval "$(register-python-argcomplete pipx)"
    - require:
      - rchook file for Pipx exists for user '{{ user.name }}'

{%-   if "zsh" == user.shell %}

Info about Pipx completions:
  test.show_notification:
    - text: |
        Pipx completions were installed to rchook file for user
        '{{ user.name }}', whose default shell seems to be zsh.
        The position for the line loading the completions matters and
        cannot be automatically deduced correctly. It needs to be
        placed before `autoload -U bashcompinit && bashcompinit`,
        but after `compinit`.
    - onchanges:
      - Pipx completions are loaded on shell startup for user '{{ user.name }}'
{%-   endif %}
{%- endfor %}

# vim: ft=sls
