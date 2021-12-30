"""
Managing python programs with pipx
======================================================

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

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.installed poetry user=user

    name
        The name of the program to install, if not installed already.

    user
        The username to install the program for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["pipx.is_installed"](name, user):
            ret["comment"] = "Program is already installed with pipx."
            return ret
        if __salt__["pipx.install"](name, user):
            ret["comment"] = "Program '{}' was installed for user '{}'.".format(name, user)
            ret["changes"] = {'installed': name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def uptodate(name, user=None):
    """
    Make sure program is installed with pipx and is up to date.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.uptodate poetry user=user

    name
        The name of the program to upgrade or install.

    user
        The username to install the program for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if __salt__["pipx.is_installed"](name, user) and __salt__["pipx.upgrade"](name, user):
            ret["comment"] = "Program '{}' was upgraded for user '{}'.".format(name, user)
            ret["changes"] = {'upgraded': name}
        elif __salt__["pipx.install"](name, user):
            ret["comment"] = "Program '{}' was installed for user '{}'.".format(name, user)
            ret["changes"] = {'installed': name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."
        return ret

    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret


def absent(name, user=None):
    """
    Make sure pipx installation of program is removed.

    CLI Example:

    .. code-block:: bash

        salt '*' pipx.absent poetry

    name
        The name of the program to remove, if installed.

    user
        The username to remove the program for. Defaults to salt user.

    """
    ret = {"name": name, "result": True, "comment": "", "changes": {}}

    try:
        if not __salt__["pipx.is_installed"](name, user):
            ret["comment"] = "Program is already absent from pipx."
            return ret
        if __salt__["pipx.remove"](name, user):
            ret["comment"] = "Program '{}' was removed for user '{}'.".format(name, user)
            ret["changes"] = {'installed': name}
        else:
            ret["result"] = False
            ret["comment"] = "Something went wrong while calling pipx."
    except salt.exceptions.CommandExecutionError as e:
        ret["result"] = False
        ret["comment"] = str(e)

    return ret
