from salt.exceptions import CommandExecutionError
import salt.utils.platform
import json
from pkg_resources import packaging
import logging

log = logging.getLogger(__name__)

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


def is_outdated(name, user=None, endpoint='https://pypi.org/pypi/{}/json'):
    current_all = _list_installed(user, versions=True)
    current = current_all.get(name)

    if current is None:
        raise CommandExecutionError("{} is not installed for user {}.".format(name, user))

    latest = _get_latest_version(name, endpoint)

    return packaging.version.parse(current) < packaging.version.parse(latest)


def _get_latest_version(name, endpoint='https://pypi.org/pypi/{}/json'):
    # for simplicity, this uses the pypi json endpoint,
    # not the simple API (ironically) because it's html
    # the latter would be preferred for compatibility reasons
    api_url = endpoint.format(name)
    log.info('Looking up version for {} at {}'.format(name, api_url))
    response = __salt__['http.query'](api_url, decode=True, decode_type='json')
    log.debug('Parsed response:\n\n{}'.format(response['dict']))
    return response['dict']['info']['version']


def _list_installed(user=None, versions=False):
    e = _which(user)
    try:
        out = json.loads(__salt__['cmd.run_stdout']('{} list --json'.format(e), runas=user, raise_err=True))
    except json.JSONDecodeError as e:
        raise CommandExecutionError(str(e))

    tools = list(out['venvs'].keys())

    if versions:
        versions = []
        for tool in tools:
            versions.append(out['venvs'][tool]['metadata']['main_package']['package_version'])
        return dict(zip(tools, versions))

    return tools
