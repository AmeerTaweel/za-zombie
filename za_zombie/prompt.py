from rich.console import Console

def mandatory(msg: str) -> str:
    console = Console()
    answer = console.input(f"[[bold yellow]*[/]] [bold cyan]{msg}:[/] ")
    return answer if answer else mandatory(msg)

def optional(msg: str) -> str:
    console = Console()
    return console.input(f"[ ] [bold cyan]{msg}:[/] ")

def mandatory_list(msg: str, count: int) -> list[str]:
    answers = []
    for _ in range(count):
        answers.append(mandatory(msg))
    return answers

def optional_list(msg: str) -> list[str]:
    answers = []
    while True:
        answer = optional(msg)
        if not answer:
            break
        answers.append(answer)
    return answers

def dynamic_list(msg: str, mandatory_count: int = 0) -> list[str]:
    return mandatory_list(msg, mandatory_count) + optional_list(msg)
