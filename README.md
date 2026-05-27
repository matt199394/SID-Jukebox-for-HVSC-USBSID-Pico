# SID Jukebox for HVSC + USBSID-Pico

The script is designed for fast browsing and playback of large SID collection like HVSC through a real hardware like USBSID-Pico https://github.com/LouDnl/USBSID-Pico

## Features

* Full HVSC support
* Recursive scanning of `.sid` and `.rsid` files
* Real SID playback through USBSID-Pico
* Interactive search using `fzf`
* Next / previous song navigation
* Subtune selection
* Random playback
* Playback timeout support
* Lightweight and fast terminal interface
* Compatible with Ubuntu/Linux

## Required Hardware

### USBSID-Pico

The project uses a real SID chip connected through a USB interface based on Raspberry Pi Pico / RP2040 USBSID-Pico https://github.com/LouDnl/USBSID-Pico

Supported SID chips:

* MOS 6581
* MOS 8581

The USBSID-Pico acts as a USB SID playback device and is supported directly by `sidplayfp`.

## Required Software

### Main components

* `sidplayfp`
* `libsidplayfp`
* `reSIDfp`
* `fzf`
* HVSC (High Voltage SID Collection)

### Recommended Linux packages

Ubuntu/Debian:

```bash
sudo apt install build-essential git fzf
```

## Building sidplayfp with USBSID support

Compile and install:

1. `reSIDfp` https://github.com/libsidplayfp/libresidfp
2. `libsidplayfp` https://github.com/libsidplayfp/libsidplayfp
3. `sidplayfp` https://github.com/libsidplayfp/sidplayfp

`libsidplayfp` must be configured with:

```bash
./configure --with-usbsid
```

Then rebuild and reinstall `sidplayfp`.

Playback through hardware SID is enabled using:

```bash
sidplayfp --usbsid file.sid
```

## HVSC

The script is designed to work with the High Voltage SID Collection (HVSC).

HVSC contains thousands of SID tunes from:

* games
* demos
* scene releases
* music collections

The script recursively scans the entire collection.

## Keyboard Controls

* `n` or Right Arrow → next song
* `p` or Left Arrow → previous song
* `+` → next subtune
* `-` → previous subtune
* `r` → random song
* `s` → interactive search
* `q` → quit

## Search

Interactive search is powered by `fzf`, allowing instant filtering of very large HVSC collections by:

* filename
* composer
* directory name
* partial text matches

## Notes

Place sidjukebox.sh inside the root folder containing your SID files (for example the main HVSC directory), then run it from there:

chmod +x sidjukebox.sh
./sidjukebox.sh

The script scans the current directory recursively and indexes all .sid and .rsid files found in subfolders.

Example:

HVSC/

├── C64Music/

├── DOCUMENTS/

├── sidjukebox.sh

Some SID files contain multiple subtunes.
Use the keyboard controls to switch between subtunes during playback.
