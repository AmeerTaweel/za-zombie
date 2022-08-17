import argparse

from za_zombie import prompt, log
from za_zombie.download import download_youtube_song
from za_zombie.tags import set_tags

def main() -> int:
    args = _parse_args()
    url = args.song_url

    _print_welcome_msg()
    _print_welcome_notes()

    filename, name, artists, tags, version_of = _get_song_metadata()

    log.info("Download started.", prepend = True)
    
    is_ok = download_youtube_song(url, filename)

    if not is_ok:
        log.error("Download failed, check for any leftover files manually.")
        return 1

    log.success("Download completed.")

    log.info("Setting tags.", prepend = True)

    is_ok = set_tags(url, filename, name, artists, tags, version_of)

    if not is_ok:
        log.error("Setting tags failed, check for any leftover files manually.")
        return 1

    log.success("Setting tags completed.")

    return 0

## Args

def _parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        dest = "song_url",
        type = str,
        help = "YouTube URL of the song to download"
    )
    return parser.parse_args()

## Welcome

def _print_welcome_msg() -> None:
    log.plain("[bold]+----------------------+[/]", include_time = False, prepend = True)
    log.plain("[bold]| Welcome to Za Zombie |[/]", include_time = False)
    log.plain("[bold]+----------------------+[/]", include_time = False, append = True)

def _print_welcome_notes() -> None:
    log.note("Mandatory fields are marked with [yellow bold]*[/].")
    log.note("Please input filename without extension.", append = True)

## Prompts

def _get_song_metadata() -> tuple[str, str, list[str], list[str], str]:
    filename = prompt.mandatory("File Name  ")
    name = prompt.mandatory("Song Name  ")
    artists = prompt.dynamic_list("Artist     ", 1)
    tags = prompt.optional_list("Tag        ")
    version_of = prompt.optional("Version Of ")
    return filename, name, artists, tags, version_of
