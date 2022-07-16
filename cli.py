import sys
import platform
import subprocess
from wasabi import msg


def start():
    if platform.system() == "Windows":
        subprocess.run(["start.bat"])
    else:
        subprocess.run(["./start"])


def stop():
    if platform.system() == "Windows":
        subprocess.run(["stop.bat"])
    else:
        subprocess.run(["./stop"])


def main():
    cli_args = sys.argv[1:]
    if len(cli_args) == 0:
        msg.fail("Please provide arguments when running the `refinery` command.")
        msg.fail("`refinery start` to start the server, `refinery stop` to end it.")
    command = cli_args[0]
    if command == "start":
        start()
    elif command == "stop":
        stop()
    else:
        msg.fail(
            f"Could not understand command `{command}`. Type `refinery help` for some instructions."
        )
