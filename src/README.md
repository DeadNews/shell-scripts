# Misc

## Remove album art from MP3 files

```sh
fd -e mp3 -x mid3v2 --delete-frames=APIC {}
```

## Remove duplicate files in the current directory and subdirectories

```sh
fdupes --reverse --delete --noprompt .
```

## Find directories without audio files

```sh
fd -t d -x sh -c 'fd --glob "*.{flac,m4a,mp3}" "$0" | grep -q . || echo "$0"' {}
```
