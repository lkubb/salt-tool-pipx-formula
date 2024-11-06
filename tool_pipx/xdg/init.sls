# vim: ft=sls

{#-
    Ensures Pipx adheres to the XDG spec
    as best as possible for all managed users.
    Has a dependency on `tool_pipx.package`_.
#}

include:
  - .migrated
