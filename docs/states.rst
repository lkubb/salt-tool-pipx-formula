Available States
================

The following states are found in this formula:


completions
-----------
Install Pipx completions into user's rchook file.

Mind that for ``zsh``, the position of the line loading
the completions matters. It needs to be placed before
``autoload -U bashcompinit && bashcompinit``, but after
``compinit``.


