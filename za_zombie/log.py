from datetime import datetime

from functools import wraps

from rich.console import Console

def _conditional_print(cond: bool):
    console = Console()
    if cond:
        console.print()

def log_method(func):
    @wraps(func)
    def wrapper(msg: str = "", prepend: bool = False, append: bool = False, include_time: bool = True):
        _conditional_print(prepend)
        if include_time:
            _log_time()
        func(msg)
        _conditional_print(append)
    return wrapper

def _log_time() -> None:
    current_time = datetime.now()
    hour = current_time.hour
    minute = current_time.minute
    second = current_time.second
    console = Console()
    console.print(f"[{hour:02}:{minute:02}:{second:02}]", end = " ")

@log_method
def plain(msg: str = "") -> None:
    console = Console()
    console.print(msg)

@log_method
def note(msg: str = "") -> None:
    console = Console()
    console.print(f"[blue bold]NOTE:[/] {msg}")

@log_method
def info(msg: str = "") -> None:
    console = Console()
    console.print(f"[cyan bold]INFO:[/] {msg}")

@log_method
def error(msg: str = "") -> None:
    console = Console()
    console.print(f"[red bold]ERRR:[/] {msg}")

@log_method
def success(msg: str = "") -> None:
    console = Console()
    console.print(f"[green bold]SUCC:[/] {msg}")
