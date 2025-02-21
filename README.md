# Scripts to play Music for CLI lovers

## Necessary settings to make script work better
> make sure you have `playmusic` setup as alias or as a link to the `play.sh` script file

## Necessary environment variables
> set `SONGDIR` variable as the path to the directory of songs

> set `LYRCDIR` variable as the path to the directory of lyrics

# Idea of the Project
> This project uses `mpv` media player to play songs,
currently only online links are part of main song search list

## useful commands
> to play songs from online sources, which are listed in the `songs_link.txt` file use the command
    ``` playmusic <song_name> ```


> to play songs from local folder use the command
    ``` playmusic genre <genre_type>```
> to set genre you can use `metaflac` command or `id3v2` for mp3 or ogg songs and `exiftool` for m4a songs.

> or even simple, just run `genreCheck.sh` script and it will display all songs without a genre. Currently it only search for three genres: `Romantic, Sad, Uplifting`.
