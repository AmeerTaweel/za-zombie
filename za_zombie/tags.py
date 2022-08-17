from mutagen.flac import FLAC as flac

def set_tags(url: str, filename: str, name: str, artists: list[str], tags: list[str], version_of: str) -> bool:
    try:
        audio = flac(f"{filename}.flac")
        audio["TITLE"] = name
        audio["ARTIST"] = artists[0]
        audio["ARTISTS"] = artists
        audio["GENRE"] = tags
        audio["ZA-ZOMBIE-YOUTUBE-URL"] = url
        audio["ZA-ZOMBIE-FILENAME"] = filename
        audio["ZA-ZOMBIE-NAME"] = name
        audio["ZA-ZOMBIE-ARTISTS"] = artists
        audio["ZA-ZOMBIE-TAGS"] = tags
        audio["ZA-ZOMBIE-VERSION-OF"] = version_of
        audio.save()
        return True
    except:
        return False
