import os
import sys
import platform
import subprocess
from git import Repo
from wasabi import msg

REFINERY_REPO = "https://github.com/code-kern-ai/refinery"
REFINERY_FOLDER = "refinery"


def start(cur_dir: str):
    """Starts the refinery server; if the refinery repository does not exist, it will be cloned from git first.

    Args:
        cur_dir (str): The current directory.
    """

    def _start_server():
        if platform.system() == "Windows":
            subprocess.run(["start.bat"])
        else:
            subprocess.run(["./start"])

    if not os.path.exists(REFINERY_FOLDER):
        msg.info(
            f"Cloning from code-kern-ai/refinery into repository {REFINERY_FOLDER}"
        )
        Repo.clone_from(REFINERY_REPO, REFINERY_FOLDER)
        with cd(REFINERY_FOLDER):
            _start_server()
    elif cur_dir == REFINERY_FOLDER:
        _start_server()
    else:
        with cd(REFINERY_FOLDER):
            _start_server()


def stop(cur_dir: str):
    """Stops the refinery server.

    Args:
        cur_dir (str): The current directory.
    """

    def _stop_server():
        if platform.system() == "Windows":
            subprocess.run(["stop.bat"])
        else:
            subprocess.run(["./stop"])

    if cur_dir == REFINERY_FOLDER:
        _stop_server()
    elif os.path.exists(REFINERY_FOLDER):
        with cd(REFINERY_FOLDER):
            _stop_server()
    else:
        msg.fail(f"Could not find repository {REFINERY_FOLDER}.")


def update(cur_dir: str):
    """Updates the refinery repository.

    Args:
        cur_dir (str): The current directory.
    """

    def _update():
        if platform.system() == "Windows":
            subprocess.run(["update.bat"])
        else:
            subprocess.run(["./update"])

    if cur_dir == REFINERY_FOLDER:
        _update()
    elif os.path.exists(REFINERY_FOLDER):
        with cd(REFINERY_FOLDER):
            _update()
    else:
        msg.fail(f"Could not find repository {REFINERY_FOLDER}.")


def help():
    msg.info("Available commands:")
    msg.info(" - `refinery start` to start the server")
    msg.info(" - `refinery stop` to end it")
    msg.info(" - `refinery update` to update the repository")


def main():
    cli_args = sys.argv[1:]
    if len(cli_args) == 0:
        msg.fail("Please provide arguments when running the `refinery` command.")
        msg.fail("`refinery start` to start the server, `refinery stop` to end it.")
    command = cli_args[0]
    cur_dir = os.path.split(os.getcwd())[-1]
    if command == "start":
        start(cur_dir)
    elif command == "stop":
        stop(cur_dir)
    elif command == "update":
        update(cur_dir)
    elif command == "help":
        help()
    else:
        msg.fail(
            f"Could not understand command `{command}`. Type `refinery help` for some instructions."
        )


# https://stackoverflow.com/questions/431684/equivalent-of-shell-cd-command-to-change-the-working-directory/24176022#24176022
class cd:
    """Context manager for changing the current working directory"""

    def __init__(self, new_path):
        self.new_path = os.path.expanduser(new_path)

    def __enter__(self):
        self.saved_path = os.getcwd()
        os.chdir(self.new_path)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.saved_path)
