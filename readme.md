# Graphmosphere
A Twitter Bot that create geometric pictures and gifs from static noises.  
https://twitter.com/graphmosphere

## Ubuntu Server 16
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get install unzip
	sudo apt-get install libxrender1
	sudo apt-get install libxtst6
	sudo apt-get install libxi6
	
## Install Java 8
	sudo add-apt-repository ppa:webupd8team/java
	sudo apt-get update
	sudo apt-get install oracle-java8-installer

## Install Processing 3
	wget http://download.processing.org/processing-3.1.1-linux64.tgz
	sudo tar fx processing-3.1.1-linux64.tgz -C /usr/local/lib
	rm -f processing-3.1.1-linux64.tgz

	VER="$(basename $(ls -dvr /usr/local/lib/processing-* | head -1))"
	sudo rm -rf /usr/local/lib/processing
	sudo ln -s $VER /usr/local/lib/processing
	
	sudo ln -sf ../lib/processing/processing /usr/local/bin/processing
	sudo ln -sf ../lib/processing/processing-java /usr/local/bin/processing-java
	
## Install Processing Libraries
	Unzip libraries.zip into your default Processing libraries folder and get the following structure:
		libraries/GifAnimation
		libraries/httpclient
		libraries/twitter4j404

## Set your tokens
	Set your Twitter token
		Data/config.json
	Set your Random.org token
		Data/randomPost.json
		
		
# Instructions for a headless shell process
## Install XDummy
	sudo apt-get install xpra
	sudo apt-get install x11vnc
	sudo apt-get install xserver-xorg-video-dummy
	
	sudo vim /usr/share/X11/xorg.conf.d/xorg.conf
	## Add these lines:
		Section "Device"
			Identifier  "Configured Video Device"
			Driver      "dummy"
		EndSection

		Section "Monitor"
			Identifier  "Configured Monitor"
			HorizSync 31.5-48.5
			VertRefresh 50-70
		EndSection

		Section "Screen"
			Identifier  "Default Screen"
			Monitor     "Configured Monitor"
			Device      "Configured Video Device"
			DefaultDepth 24
			SubSection "Display"
			Depth 24
			Modes "1024x800"
			EndSubSection
		EndSection

## Download Processing Project & Libraries and prepare .sh file
	sudo vim graph_shell.sh
	## Add these lines:
		cd /home/username/
		echo "Start Draw: $(date)" >> /home/username/graph.log
		export DISPLAY=:0
		/usr/local/bin/processing-java --sketch=`pwd`/sketchbook/Graphmosphere --run

	sudo chmod +x graph_shell.sh
	
## Configure crontab
	crontab -e
	# Add these lines
		@reboot xpra --xvfb="Xorg -noreset -nolisten tcp +extension GLX	-config /etc/xpra/xorg.conf	+extension RANDR +extension RENDER -logfile ${HOME}/.xpra/Xorg-10.log" start :0
		*/30 * * * * /home/username/graph_shell.sh >> /home/username/graph.log 2>&1

	sudo reboot -p