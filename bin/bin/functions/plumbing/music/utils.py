import shutil
import mimetypes
import os
import mutagen
import re

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
                meta = mutagen.File(f)
                artist = meta["TPE2"].text[0]
                album = meta["TALB"].text[0]
                break

        for (mt, f) in files:
            if mt.find('audio') > -1:
                meta = mutagen.File(f)
                artist = meta["TPE2"].text[0]
                album = meta["TALB"].text[0]
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
    return re.sub(r"[\"*:<>?\\|]", "_", path)
