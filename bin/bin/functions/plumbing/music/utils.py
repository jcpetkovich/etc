import shutil
import mimetypes
import os
import mutagen
import re

def get_meta(filepath):
    """Return a standardized but simplistic set of metadata for a song.

    Parameters
    ----------
    filepath : str
        The path to the music file.

    Returns
    -------
    dict
        Dictionary containing simplified and standardized metadata.

    """

    meta = {}
    muta = mutagen.File(filepath)
    # ARTIST
    if "TPE2" in muta:
        meta["artist"] = muta["TPE2"].text[0]
    elif "artist" in muta:
        meta["artist"] = muta["artist"][0]
    else:
        meta["artist"] = muta["TPE1"].text[0]

    # ALBUM
    if "TALB" in muta:
        meta["album"] = muta["TALB"].text[0]
    elif "album" in muta:
        meta["album"] = muta["album"][0]
    return meta

def get_music(musicdir, targetdir):
    for root, dirs, files in os.walk(musicdir):

        files = [os.path.join(root, f) for f in files]
        files = [(mimetypes.guess_type(f)[0], f) for f in files]

        musictuples = []
        artist = None
        album = None

        dirs = [os.path.join(root, d) for d in dirs]
        for d in dirs:
            subtuples = get_music(d, targetdir)
            musictuples.extend(subtuples)

        # get first album/artist
        for (mt, f) in files:
            if mt.find('audio') > -1:
                meta = get_meta(f)
                artist = meta["artist"]
                album = meta["album"]
                break

        for (mt, f) in files:
            if mt.find('audio') > -1:
                meta = get_meta(f)
                artist = meta["artist"]
                album = meta["album"]
            musictuples.append((
                os.path.join(
                    targetdir,
                    "{artist}/{album}",
                    os.path.basename(f)
                ).format(artist = artist, album = album),
                f
            ))

        return musictuples

def copy_music(musictuples):
    for (destination, source) in musictuples:
        print(destination)
        print(source)
        dir = os.path.dirname(destination)
        print(dir)
        if not os.path.exists(dir):
            os.makedirs(dir)
        shutil.copy(source, destination)

def safe_fatpath(path):
    return re.sub(r"[\"*:<>?\\|]", "_", path).encode('ascii', 'ignore')
