"""
pipx salt execution module
======================================================

Manage python executable packages with pipx.
"""

import json
import logging

import salt.utils.platform
from pkg_resources import packaging
from salt.exceptions import CommandExecutionError

log = logging.getLogger(__name__)

__virtualname__ = "pipx"


def __virtual__():
    return __virtualname__


def _which(user=None):
    if exe := __salt__["cmd.run_stdout"]("command -v pipx", runas=user):
        return exe
    if salt.utils.platform.is_darwin():
        if exe := __salt__["cmd.run_stdout"]("brew --prefix pipx", runas=user):
            return exe
    raise CommandExecutionError("Could not find pipx executable.")


def is_installed(name, user=None):
    """
    Checks whether a package with this name is installed by pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.is_installed poetry user=user

    name
        The name of the package to check.

    user
        The username to check for. Defaults to salt user.
    """

    return name in _list_installed(user)


def install(name, user=None):
    """
    Installs package with pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.install poetry user=user

    name
        The name of the package to install.

    user
        The username to install the package for. Defaults to salt user.
    """
    return not __salt__["cmd.retcode"](f"{_which(user)} install '{name}'", runas=user)


def remove(name, user=None):
    """
    Removes package installed with pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.remove poetry user=user

    name
        The name of the package to remove.

    user
        The username to remove the package for. Defaults to salt user.
    """
    return not __salt__["cmd.retcode"](f"{_which(user)} uninstall '{name}'", runas=user)


def remove_all(user=None):
    """
    Removes all packages installed with pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.remove_all user=user

    user
        The username to remove all packages for. Defaults to salt user.
    """
    return not __salt__["cmd.retcode"](f"{_which(user)} uninstall-all", runas=user)


def upgrade(name, user=None):
    """
    Upgrades package installed with pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.upgrade poetry user=user

    name
        The name of the package to upgrade.

    user
        The username to upgrade the package for. Defaults to salt user.
    """
    return not __salt__["cmd.retcode"](f"{_which(user)} upgrade '{name}'", runas=user)


def reinstall(name, user=None):
    """
    Reinstalls package installed with pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.reinstall poetry user=user

    name
        The name of the package to reinstall.

    user
        The username to reinstall the package for. Defaults to salt user.
    """
    return not __salt__["cmd.retcode"](f"{_which(user)} reinstall '{name}'", runas=user)


def upgrade_all(user=None):
    """
    Upgrades all packages installed with pipx.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.upgrade_all user=user

    user
        The username to upgrade all packages for. Defaults to salt user.
    """
    return not __salt__["cmd.retcode"](f"{_which(user)} upgrade-all", runas=user)


def is_outdated(
    name, user=None, endpoint="https://pypi.org/pypi/{}/json", get_versions=False
):
    """
    Checks whether a package installed with pipx can be upgraded.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.is_outdated poetry user=user

    name
        The name of the package to check.

    user
        The username to check the package for. Defaults to salt user.

    endpoint
        JSON endpoint to query, containing a marker for the package name.
        Defaults to ``https://pypi.org/pypi/{}/json``.
    """

    current_all = _list_installed(user, versions=True)
    current = current_all.get(name)

    if current is None:
        raise CommandExecutionError(f"{name} is not installed for user {user}.")

    latest = _get_latest_version(name, endpoint)

    res = packaging.version.parse(current) < packaging.version.parse(latest)
    if get_versions:
        return res, current, latest
    return res


def _get_latest_version(name, endpoint="https://pypi.org/pypi/{}/json"):
    # for simplicity, this uses the pypi json endpoint,
    # not the simple API (ironically) because it's html
    # the latter would be preferred for compatibility reasons
    api_url = endpoint.format(name)
    log.info("Looking up version for {} at {}".format(name, api_url))
    response = __salt__["http.query"](api_url, decode=True, decode_type="json")
    log.debug("Parsed response:\n\n{}".format(response["dict"]))
    return response["dict"]["info"]["version"]


def _list_installed(user=None, versions=False):
    try:
        out = json.loads(
            __salt__["cmd.run_stdout"](
                f"{_which(user)} list --json", runas=user, raise_err=True
            )
        )
    except json.JSONDecodeError as e:
        raise CommandExecutionError(str(e))

    tools = list(out["venvs"])

    if versions:
        versions = []
        for tool in tools:
            versions.append(
                out["venvs"][tool]["metadata"]["main_package"]["package_version"]
            )
        return dict(zip(tools, versions))

    return tools
