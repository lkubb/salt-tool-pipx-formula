.. _readme:

Pipx Formula
============

Manages Pipx in the user environment.

.. contents:: **Table of Contents**
   :depth: 1

Usage
-----
Applying ``tool_pipx`` will make sure ``pipx`` is configured as specified.

Execution and state module
~~~~~~~~~~~~~~~~~~~~~~~~~~
This formula provides a custom execution module and state to manage packages installed with Pipx. The functions are self-explanatory, please see the source code or the rendered docs at :ref:`em_pipx` and :ref:`sm_pipx`.

Common problems
---------------
* Especially on MacOS + Homebrew, after brew upgraded its Python, `all installed packages will be broken <https://github.com/pypa/pipx/issues/146>`_. A workaround is to issue ``pipx reinstall-all``. It might make sense to depend on a different, more stable ``python``, e.g. ``pipx reinstall-all --python /usr/bin/python3``.

Configuration
-------------

This formula
~~~~~~~~~~~~
The general configuration structure is in line with all other formulae from the `tool` suite, for details see :ref:`toolsuite`. An example pillar is provided, see :ref:`pillar.example`. Note that you do not need to specify everything by pillar. Often, it's much easier and less resource-heavy to use the ``parameters/<grain>/<value>.yaml`` files for non-sensitive settings. The underlying logic is explained in :ref:`map.jinja`.

User-specific
^^^^^^^^^^^^^
The following shows an example of ``tool_pipx`` per-user configuration. If provided by pillar, namespace it to ``tool_global:users`` and/or ``tool_pipx:users``. For the ``parameters`` YAML file variant, it needs to be nested under a ``values`` parent key. The YAML files are expected to be found in

1. ``salt://tool_pipx/parameters/<grain>/<value>.yaml`` or
2. ``salt://tool_global/parameters/<grain>/<value>.yaml``.

.. code-block:: yaml

  user:

      # Force the usage of XDG directories for this user.
    xdg: true

      # Put shell completions into this directory, relative to user home.
    completions: '.config/zsh/completions'

      # Persist environment variables used by this formula for this
      # user to this file (will be appended to a file relative to $HOME)
    persistenv: '.config/zsh/zshenv'

      # Add runcom hooks specific to this formula to this file
      # for this user (will be appended to a file relative to $HOME)
    rchook: '.config/zsh/zshrc'

      # This user's configuration for this formula. Will be overridden by
      # user-specific configuration in `tool_pipx:users`.
      # Set this to `false` to disable configuration for this user.
    pipx:
        # packages to install with pipx (convenience)
      packages:
        - cookiecutter
        - cruft
        - poetry

Formula-specific
^^^^^^^^^^^^^^^^

.. code-block:: yaml

  tool_pipx:

      # Specify an explicit version (works on most Linux distributions) or
      # keep the packages updated to their latest version on subsequent runs
      # by leaving version empty or setting it to 'latest'
      # (again for Linux, brew does that anyways).
    version: latest
    install_method: pkg

      # Default formula configuration for all users.
    defaults:
      packages: default value for all users

<INSERT_STATES>

Development
-----------

Contributing to this repo
~~~~~~~~~~~~~~~~~~~~~~~~~

Commit messages
^^^^^^^^^^^^^^^

Commit message formatting is significant.

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

pre-commit
^^^^^^^^^^

`pre-commit <https://pre-commit.com/>`_ is configured for this formula, which you may optionally use to ease the steps involved in submitting your changes.
First install  the ``pre-commit`` package manager using the appropriate `method <https://pre-commit.com/#installation>`_, then run ``bin/install-hooks`` and
now ``pre-commit`` will run automatically on each ``git commit``.

.. code-block:: console

  $ bin/install-hooks
  pre-commit installed at .git/hooks/pre-commit
  pre-commit installed at .git/hooks/commit-msg

State documentation
~~~~~~~~~~~~~~~~~~~
There is a script that semi-autodocuments available states: ``bin/slsdoc``.

If a ``.sls`` file begins with a Jinja comment, it will dump that into the docs. It can be configured differently depending on the formula. See the script source code for details currently.

This means if you feel a state should be documented, make sure to write a comment explaining it.
