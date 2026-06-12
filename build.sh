#!/bin/sh

rm -rf ./BeatSketch
rm -rf ./BeatSketch.exe

set -e

echo "
==> Zipping BeatSketch VR
"
mkdir build/
cp -r core build
cp -r ui build
cp -r util build
cp -r json.lua build
cp -r main.lua build
mkdir build/assets
cp assets/*.mtl build/assets
cp assets/*.obj build/assets
cd build

zip -9qr BeatSketch.lovr .

cd ..
cp build/BeatSketch.lovr .

rm -rf ./build/

# Build for GNU/Linux
if [ "$1" == "true" ]; then
	echo "
==> Building for Linux
    "
	if [ -e "/usr/bin/lovr" ]; then
		echo "Using locally installed lovr"
		cat /usr/bin/lovr BeatSketch.lovr >BeatSketch
	else
		if [ -d "./LOVR-Linux/" ]; then
			echo "LOVR-Linux already exists, skipping download"
			cd LOVR-Linux
		else
			mkdir LOVR-Linux
			cd LOVR-Linux
			wget -O lovr https://github.com/bjornbytes/lovr/releases/download/v0.18.0/lovr-v0.18.0-x86_64.AppImage
			chmod +x lovr
		fi
		cp lovr ..
		cd ..
		cat ./lovr BeatSketch.lovr >BeatSketch
		rm lovr
	fi
	chmod +x ./BeatSketch
	echo "-> Build succeeded"
fi

# Build for the peasants (Windows users)
if [ "$2" == "true" ]; then
	echo "
==> Building for Windows
    "
	if [ -d "./LOVR-Windows/" ]; then
		echo "LOVR-Windows already exists, skipping download"
		cd LOVR-Windows
	else
		mkdir LOVR-Windows
		cd LOVR-Windows
		wget -O https://github.com/bjornbytes/lovr/releases/download/v0.18.0/lovr-v0.18.0-win64.zip
		unzip windows
		rm windows
	fi

	cp ../BeatSketch.lovr .
	cat ./lovr.exe BeatSketch.lovr >BeatSketch.exe
	rm BeatSketch.lovr
	cp BeatSketch.exe ..
	cd ..
	rm BeatSketch.lovr
	echo "-> Build succeeded"
fi

# Build for Mac
# TODO: Mac Build
if [ "$3" == "true" ]; then
	echo "
==> Building for Mac
    "
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
	echo "-> Build succeeded"
fi
