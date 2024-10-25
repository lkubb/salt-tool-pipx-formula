"""
pipx salt state module
======================================================

Manage python executable packages with pipx.
"""

# import logging
import salt.exceptions

# import salt.utils.platform

# log = logging.getLogger(__name__)

__virtualname__ = "pipx"


def __virtual__():
    return __virtualname__


def installed(name, user=None):
    """
    Make sure program is installed with pipx.

    name
        The name of the program to install, if not installed already.

    user
        The username to install the program for. Defaults to salt user.
    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["pipx.is_installed"](name, user):
            ret["comment"] = "Package is already installed with pipx."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = f"Package '{name}' would have been installed for user '{user}'."
            ret["changes"] = {"installed": name}
        elif __salt__["pipx.install"](name, user):
            ret["comment"] = f"Package '{name}' was installed for user '{user}'."
            ret["changes"] = {"installed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def latest(name, user=None):
    """
    Make sure program is installed with pipx and is up to date.

    name
        The name of the program to upgrade or install.

    user
        The username to install the program for. Defaults to salt user.
    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["pipx.is_installed"](name, user):
            return installed(name, user)
        outdated, curr, latest = __salt__["pipx.is_outdated"](
            name, user, get_versions=True
        )
        if not outdated:
            ret[
                "comment"
            ] = f"Package '{name}' is already at the latest version for user '{user}'."
            return ret
        if __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = f"Package '{name}' would have been upgraded for user '{user}'."
            ret["changes"] = {"upgraded": {name: {"old": curr, "new": latest}}}
            return ret
        if __salt__["pipx.upgrade"](name, user):
            ret["comment"] = f"Package '{name}' was upgraded for user '{user}'."
            ret["changes"] = {"upgraded": {name: {"old": curr, "new": latest}}}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."

    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def absent(name, user=None):
    """
    Make sure pipx installation of program is removed.

    name
        The name of the program to remove, if installed.

    user
        The username to remove the program for. Defaults to salt user.
    """

    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["pipx.is_installed"](name, user):
            ret["comment"] = "Package is already absent from pipx."
        elif __opts__["test"]:
            ret["result"] = None
            ret[
                "comment"
            ] = f"Package '{name}' would have been removed for user '{user}'."
            ret["changes"] = {"removed": name}
        elif __salt__["pipx.remove"](name, user):
            ret["comment"] = f"Package '{name}' was removed for user '{user}'."
            ret["changes"] = {"removed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
