#!/bin/sh

set -e
# Build for GNU/Linux
if [ "$1" == "true" ]; then
	echo "
==> Building for Linux
    "
	zip -9qr BeatSketch.lovr .
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
			wget -O lovr https://lovr.org/download/linux
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
		wget https://lovr.org/download/windows
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
