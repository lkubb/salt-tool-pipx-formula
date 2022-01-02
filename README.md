# `pipx` Formula
Sets up, configures and updates `pipx`.

## Usage
Applying `tool-pipx` will make sure `pipx` is configured as specified and requested packages are installed.

### Execution module and state
This formula provides a custom execution module and state to manage packages installed with pipx. The functions are self-explanatory, please see the source code for comments. Currently, the following states are supported:
* `pipx.installed(name, user)`
* `pipx.absent(name, user)`
* `pipx.uptodate(name, user)`

## Configuration
### Pillar
#### General `tool` architecture
Since installing user environments is not the primary use case for saltstack, the architecture is currently a bit awkward. All `tool` formulas assume running as root. There are three scopes of configuration:
1. per-user `tool`-specific
  > e.g. generally force usage of XDG dirs in `tool` formulas for this user
2. per-user formula-specific
  > e.g. setup this tool with the following configuration values for this user
3. global formula-specific (All formulas will accept `defaults` for `users:username:formula` default values in this scope as well.)
  > e.g. setup system-wide configuration files like this

**3** goes into `tool:formula` (e.g. `tool:git`). Both user scopes (**1**+**2**) are mixed per user in `users`. `users` can be defined in `tool:users` and/or `tool:formula:users`, the latter taking precedence. (**1**) is namespaced directly under `username`, (**2**) is namespaced under `username: {formula: {}}`.

```yaml
tool:
######### user-scope 1+2 #########
  users:                         #
    username:                    #
      xdg: true                  #
      dotconfig: true            #
      formula:                   #
        config: value            #
####### user-scope 1+2 end #######
  formula:
    formulaspecificstuff:
      conf: val
    defaults:
      yetanotherconfig: somevalue
######### user-scope 1+2 #########
    users:                       #
      username:                  #
        xdg: false               #
        formula:                 #
          otherconfig: otherval  #
####### user-scope 1+2 end #######
```

#### User-specific
The following shows an example of `tool-pipx` pillar configuration. Namespace it to `tool:users` and/or `tool:pipx:users`.
```yaml
user:
  xdg: true                         # force xdg dirs
  persistenv: '.config/zsh/zshenv'  # persist pipx env vars to use xdg dirs permanently (will be appended to file relative to $HOME)
  rchook: '.config/zsh/zshrc'       # load completions during startup. if you're using zsh, make sure to call autoload -U bashcompinit && bashcompinit before that line
  pipx:
    packages:                       # packages to install with pipx for this user (convenience)
      - pipenv
```

#### Formula-specific
```yaml
tool:
  pipx:
    defaults:                       # default packages for all users
      packages:
        - poetry
```
