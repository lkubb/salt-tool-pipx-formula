# vim: ft=sls

{#-
    *Meta-state*.

    Undoes everything performed in the ``tool_pipx`` meta-state
    in reverse order.
#}

include:
  - .completions.clean
  - .package.clean
  - .completions.clean
  - .packages.clean
