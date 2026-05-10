#!/bin/sh

# TODO: Make builds togglable
platforms=$1

# Build for GNU/Linux
zip -9qr BeatSketch.lovr .
cat /usr/bin/lovr BeatSketch.lovr > BeatSketch
chmod +x ./BeatSketch


# Build for the peasants (Windows users)
# TODO: Needs verification (that it works)
if [ -d "./LOVR-Windows/" ]; then
    echo "LOVR-Windows already exists, skipping download"
    cd LOVR-Windows
else
    mkdir LOVR-Windows
    cd LOVR-Windows
    wget https://lovr.org/download/windows
    unzip windows
    rm windows
fi

cp ../BeatSketch.lovr .
cat ./lovr.exe BeatSketch.lovr > BeatSketch.exe
rm BeatSketch.lovr
cp BeatSketch.exe ..
cd ..
rm BeatSketch.lovr

# Build for Mac
# TODO: Mac Build
if [ -d "./LOVR-Mac/" ]; then
    echo "LOVR-Mac already exists, skipping download"
    cd LOVR-Mac
else
    mkdir LOVR-Mac
    cd LOVR-Mac
    wget https://lovr.org/download/mac
    unzip mac
    rm mac
fi

cp ../BeatSketch.lovr ./Contents/Resources
# sed the Contents/Info.plist file
# according to https://lovr.org/docs/Distribution#macos
# TODO: for the python application, build it, then create dmg for installation
