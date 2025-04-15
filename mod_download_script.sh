#!/bin/bash
# DISCLAIMER
# This work © 2025 by UASCG is licensed under CC BY-SA 4.0
# https://github.com/UASCG
# https://creativecommons.org/licenses/by-sa/4.0/deed.en
# Lines 39-56 contain code adapted from an answer by nxnev on StackExchange, used under CC BY-SA 3.0.
# https://unix.stackexchange.com/questions/388194/shell-script-to-retrieve-text-from-website
# https://unix.stackexchange.com/users/243481/nxnev
# https://creativecommons.org/licenses/by-sa/3.0/
# ABOUT
# This script automates mod downloads for Vintage Story. This is intended for mass downloads, e.g. when downloading a large batch of mods for the first time.
# Made with the intent to be used for servers, but can be used for singleplayer usage as well.
# USAGE INSTRUCTIONS
# * Requires a modlist.txt in the same directory.
# 1. Place mod_download_script.sh in the Mods directory of your Vintage Story server.
# 2. Create a file named modlist.txt in the same directory.
# 2. Copy & paste your Vintage Story ModDB mod page URLs to modlist.txt, one URL per line. Nothing else should be in the file.
# 3. Run mod_download_script.sh to download all the mods listed in modlist.txt.
# DEFINING VARIABLES & FUNCTIONS
Count=0
CountReader=1 # Used to display an user-friendly counter.
Modlist="modlist.txt" # Change this if you want to use a different name for the modlist.
ModDB="https://mods.vintagestory.at" # Prefix for download URLs.
ModURLs=()
ModNames=()
ModGameVersions=()
AppendGameVersion=true # Default: true. Appends the game version that the mod is intended for at the end of the directory name. Set to false if you want to disable this feature.
readlist () {
    if test -f "$Modlist"; then
        for i in `cat ${Modlist}`; do
            LinesInList=`wc -l ${Modlist}`
            URL=($i)
            HTML=$( curl -# -L "${URL}" 2> "/dev/null" ) # -# is same as --progress-bar. -L follows redirects. 2> '/dev/null' suppresses output by redirecting stderr.
            FileURL=$( # Finds the first matching HTML element to get the download link from the mod page.
              <<< "${HTML}" \
              grep -P -o -e '(?<=a class=\"downloadbutton\" href=\")(.*?)(?=\")' |
              head -n 1
            )
            FileURL="${ModDB}${FileURL}" # Appends proper URL prefix to download URL.
            Filename=$( # Finds filename by using URL found above.
              <<< "${FileURL}" \
              grep -P -o -e '(?<=[0-9]/)(.*?)(?=.zip)' |
              head -n 1
            )
            FileGameVersion=$( # Finds "For Game version" information from the Files tab on the mod page.
              <<< "${HTML}" \
              grep -P -o -e '(?<=C9C9C9\">#)(.*?)(?=\<)' |
              head -n 1
              )
            if [ "$AppendGameVersion" = true ] ; then
              Filename="${Filename}-for-${FileGameVersion}" # Appends game version to directory name.
            fi
            echo -e "\nCounter: $CountReader / $LinesInList"  "\nDownload URL: ${FileURL}" "\nFilename: ${Filename}" "\nFor Game Version: ${FileGameVersion}"
            ModURLs+=($FileURL)
            ModNames+=($Filename)
            ModGameVersions+=($FileGameVersion)
            (( Count++ ))
            (( CountReader++ ))
            sleep 1
        done
    else
        echo "$Modlist does not exist in the same directory where this script is located. Please double-check that your $Modlist is in the correct directory and named correctly. Stopping..."
        exit 1
    fi
}
moddownloader () {
    Count=0
    CountReader=1 # Used to display an user-friendly counter.
    echo -e "\nStarting to download mods!\n"
    sleep 1
    for i in "${ModURLs[@]}"; do
        echo -e "\nDownloading ${ModNames[Count]} from ${ModURLs[Count]} (Item $CountReader / ${#ModNames[@]})"
        wget -O "${ModNames[Count]}.zip" "${ModURLs[Count]}"
        echo -e "\nUnzipping ${ModNames[Count]} (Item $CountReader / ${#ModNames[@]})"
        unzip -q -d "${ModNames[Count]}/" "${ModNames[Count]}.zip"
        echo -e "\nRemoving zip file for ${ModNames[Count]} (Item $CountReader / ${#ModNames[@]})"
        rm "${ModNames[Count]}.zip"
        (( Count++ ))
        (( CountReader++ ))
        sleep 1
    done
    echo -e "\n\nCompleted successfully!\n"
    echo "Total number of URLs: ${#ModURLs[@]}"
    echo "URLs: ${ModURLs[@]}"
    echo "Total number of mod names: ${#ModNames[@]}"
    echo "Mods: ${ModNames[@]}"
    echo "Game versions of mods: ${ModGameVersions[@]}"
    echo "Counter final: $Count"
}
# END OF VARIABLE & FUNCTION DEFINITIONS
readlist
moddownloader
