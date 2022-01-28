from salt.exceptions import CommandExecutionError
import salt.utils.platform
import json

__virtualname__ = "pipx"


def __virtual__():
    return __virtualname__


def _which(user=None):
    e = __salt__["cmd.run"]("command -v pipx", runas=user)
    # if e := __salt__["cmd.run"]("command -v pipx", runas=user):
    if e:
        return e
    if salt.utils.platform.is_darwin():
        p = __salt__["cmd.run"]("brew --prefix pipx", runas=user)
        # if p := __salt__["cmd.run"]("brew --prefix pipx", runas=user):
        if p:
            return p
    raise CommandExecutionError("Could not find pipx executable.")


def is_installed(name, user=None):
    return name in _list_installed(user)


def install(name, user=None):
    e = _which(user)

    return not __salt__['cmd.retcode']("{} install '{}'".format(e, name), runas=user)


def remove(name, user=None):
    e = _which(user)

    return not __salt__['cmd.retcode']("{} uninstall '{}'".format(e, name), runas=user)


def remove_all(user=None):
    e = _which(user)

    return not __salt__['cmd.retcode']("{} uninstall-all".format(e), runas=user)


def upgrade(name, user=None):
    e = _which(user)

    return not __salt__['cmd.retcode']("{} upgrade '{}'".format(e, name), runas=user)


def reinstall(name, user=None):
    e = _which(user)

    return not __salt__['cmd.retcode']("{} reinstall '{}'".format(e, name), runas=user)


def upgrade_all(user=None):
    e = _which(user)

    return not __salt__['cmd.retcode']("{} upgrade-all".format(e), runas=user)


def _list_installed(user=None):
    e = _which(user)
    out = json.loads(__salt__['cmd.run_stdout']('{} list --json'.format(e), runas=user, raise_err=True))
    if out:
        return list(out['venvs'].keys())
    raise CommandExecutionError('Something went wrong while calling pipx.')
