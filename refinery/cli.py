import os
import sys
import platform
import subprocess
import re
from git import Repo
from wasabi import msg

REFINERY_REPO = "https://github.com/code-kern-ai/refinery"
REFINERY_FOLDER = "refinery"
REMOTE_REPO = "code-kern-ai/refinery.git"
MAIN_BRANCH = "main"


def start(cur_dir: str):
    """Starts the refinery server; if the refinery repository does not exist, it will be cloned from git first.

    Args:
        cur_dir (str): The current directory.
    """

    def _start_server(check_for_update: bool):

        if check_for_update:
            repo = Repo(search_parent_directories=True)
            repo_origin = repo.remotes.origin

            active_branch = str(repo.active_branch)
            repo_identifier_remote = repo_origin.url.split(":")[-1]

            if active_branch == MAIN_BRANCH and repo_identifier_remote == REMOTE_REPO:
                sha_local = repo.head.object.hexsha

                # https://stackoverflow.com/questions/62525382/how-to-get-the-latest-commit-hash-on-remote-using-gitpython
                repo_url = f"{REFINERY_REPO}.git"
                process = subprocess.Popen(
                    ["git", "ls-remote", repo_url], stdout=subprocess.PIPE
                )
                stdout, stderr = process.communicate()
                sha_remote = re.split(r"\t+", stdout.decode("ascii"))[0]

                if sha_local != sha_remote:
                    msg.info(
                        "A new version of refinery is available. Should this be pulled? (y/n)"
                    )
                    user_input = input("> ")
                    if user_input == "y":
                        repo_origin.pull()
                        msg.good(f"refinery has been updated to commit {sha_remote}.")
                    else:
                        msg.info(f"Staying on commit {sha_local}.")

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
            _start_server(check_for_update=False)
    elif cur_dir == REFINERY_FOLDER:
        _start_server(check_for_update=True)
    else:
        with cd(REFINERY_FOLDER):
            _start_server(check_for_update=True)


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
