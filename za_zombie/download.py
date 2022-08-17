import yt_dlp

def _get_download_options(filename: str) -> dict:
    return {
        "format": "bestaudio",
        "postprocessors": [{
            "key": "FFmpegExtractAudio",
            "preferredcodec": "flac"
        }],
        "outtmpl": {
            "default": f"{filename}.%(ext)s"
        },
        "quiet": True,
        "noplaylist": True
    }

def download_youtube_song(url: str, filename: str) -> bool:
    options = _get_download_options(filename)
    try:
        with yt_dlp.YoutubeDL(options) as downloader:
            has_error = downloader.download([ url ])
            return not has_error
    except:
        return False
