{%- from 'tool-pipx/map.jinja' import pipx %}

{%- for user in pipx.users | selectattr('rchook', 'defined') %}

rchook file for pipx exists for user '{{ user.name }}':
  file.managed:
    - name: {{ user.home }}/{{ user.rchook }}
    - user: {{ user.name }}
    - group: {{ user.group }}
    - replace: false
    - mode: '0600'
    - dir_mode: '0700'
    - makedirs: true

pipx completions are loaded on shell startup for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.rchook }}
    - text: |
        # load pipx completions. if you're using zsh, make sure to
        # autoload -U bashcompinit && bashcompinit
        # before here, but after compinit
        eval "$(register-python-argcomplete pipx)"
    - require:
      - rchook file for pipx exists for user '{{ user.name }}'
{%- endfor %}
