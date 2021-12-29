{%- from 'tool-pipx/map.jinja' import pipx %}

{%- for user in pipx.users | selectattr('rchook') %}
pipx completions are loaded on shell startup for user '{{ user.name }}':
  file.append:
    - name: {{ user.home }}/{{ user.rchook }}
    - text: |
        # load pipx completions. if you're using zsh, make sure to
        # autoload -U bashcompinit && bashcompinit
        # before here, but after compinit
        eval "$(register-python-argcomplete pipx)"
    - user: {{ user.name }}
    - group: {{ user.group }}
    - mode: '0600'
  {%- endif %}
{%- endfor %}
