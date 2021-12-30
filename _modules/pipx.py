from salt.exceptions import CommandExecutionError
# import logging
import json

import salt.utils.platform

# log = logging.getLogger(__name__)
__virtualname__ = "pipx"


def __virtual__():
    return __virtualname__


def _which(user=None):
    if e := salt["cmd.run"]("command -v pipx", runas=user):
        return e
    if salt.utils.platform.is_darwin():
        if p := salt["cmd.run"]("brew --prefix pipx", runas=user):
            return p
    raise CommandExecutionError("Could not find pipx executable.")


def is_installed(name, user=None):
    return name in _list_installed(user)


def install(name, user=None):
    e = _which(user)

    return __salt__['cmd.retcode']("{} install '{}'".format(e, name), runas=user)


def remove(name, user=None):
    e = _which(user)

    return __salt__['cmd.retcode']("{} uninstall '{}'".format(e, name), runas=user)


def remove_all(user=None):
    e = _which(user)

    return __salt__['cmd.retcode']("{} uninstall-all".format(e), runas=user)


def upgrade(name, user=None):
    e = _which(user)

    return __salt__['cmd.retcode']("{} upgrade '{}'".format(e, name), runas=user)


def reinstall(name, user=None):
    e = _which(user)

    return __salt__['cmd.retcode']("{} reinstall '{}'".format(e, name), runas=user)


def upgrade_all(user=None):
    e = _which(user)

    return __salt__['cmd.retcode']("{} upgrade-all".format(e), runas=user)


def _list_installed(user=None):
    e = _which(user)
    out = json.loads(__salt__['cmd.run']('{} list --json'.format(e), runas=user, raise_err=True))
    if out:
        return list(out['venvs'].keys())
    raise CommandExecutionError('Something went wrong while calling pipx.')
