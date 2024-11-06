Available states
----------------

The following states are found in this formula:

.. contents::
   :local:


``tool_pipx``
~~~~~~~~~~~~~
*Meta-state*.

Performs all operations described in this formula according to the specified configuration.


``tool_pipx.package``
~~~~~~~~~~~~~~~~~~~~~
Installs the Pipx package only.


``tool_pipx.xdg``
~~~~~~~~~~~~~~~~~
Ensures Pipx adheres to the XDG spec
as best as possible for all managed users.
Has a dependency on `tool_pipx.package`_.


``tool_pipx.completions``
~~~~~~~~~~~~~~~~~~~~~~~~~
Install Pipx completions into user's rchook file.

Mind that for ``zsh``, the position of the line loading
the completions matters. It needs to be placed before
``autoload -U bashcompinit && bashcompinit``, but after
``compinit``.


``tool_pipx.packages``
~~~~~~~~~~~~~~~~~~~~~~



``tool_pipx.clean``
~~~~~~~~~~~~~~~~~~~
*Meta-state*.

Undoes everything performed in the ``tool_pipx`` meta-state
in reverse order.


``tool_pipx.package.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~



``tool_pipx.xdg.clean``
~~~~~~~~~~~~~~~~~~~~~~~
Removes Pipx XDG compatibility crutches for all managed users.


``tool_pipx.completions.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Removes pipx completions for all managed users.


``tool_pipx.packages.clean``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~



