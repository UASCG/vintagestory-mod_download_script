# Mod Download Script for Vintage Story
This script automates mod downloads for Vintage Story. This is intended for mass downloads, e.g. when downloading a large batch of mods for the first time. Made with the intent to be used for servers, but can be used for singleplayer usage as well.

## Usage Instructions
1. Place mod_download_script.sh in the Mods directory of your Vintage Story server.
2. Create a file named modlist.txt in the same directory.
2. Copy & paste your Vintage Story ModDB mod page URLs to modlist.txt, one URL per line. Nothing else should be in the file. (see example)
3. Run mod_download_script.sh to download all the mods listed in modlist.txt.

## Disclaimer
mod_download_script.sh © 2025 by [UASCG](https://github.com/UASCG) is licensed under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en)

Lines 39-56 contain code adapted from [an answer](https://unix.stackexchange.com/questions/388194/shell-script-to-retrieve-text-from-website) by [nxnev](https://unix.stackexchange.com/users/243481/nxnev) on StackExchange, used under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)
