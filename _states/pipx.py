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
            ] = "Package '{}' would have been installed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"installed": name}
        elif __salt__["pipx.install"](name, user):
            ret["comment"] = "Package '{}' was installed for user '{}'.".format(
                name, user
            )
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
        if __salt__["pipx.is_installed"](name, user):
            if not __salt__["pipx.is_outdated"](name, user):
                ret[
                    "comment"
                ] = "Package '{}' is already at the latest version for user '{}'.".format(
                    name, user
                )
            elif __opts__["test"]:
                ret["result"] = None
                ret[
                    "comment"
                ] = "Package '{}' would have been upgraded for user '{}'.".format(
                    name, user
                )
                ret["changes"] = {"installed": name}
            elif __salt__["pipx.upgrade"](name, user):
                ret["comment"] = "Package '{}' was upgraded for user '{}'.".format(
                    name, user
                )
                ret["changes"] = {"upgraded": name}
            else:
                ret["result"] = False
                ret["comment"] = "Something went wrong while calling pipx."
        else:
            return installed(name, user)

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
            ] = "Package '{}' would have been removed for user '{}'.".format(name, user)
            ret["changes"] = {"removed": name}
        elif __salt__["pipx.remove"](name, user):
            ret["comment"] = "Package '{}' was removed for user '{}'.".format(
                name, user
            )
            ret["changes"] = {"removed": name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
