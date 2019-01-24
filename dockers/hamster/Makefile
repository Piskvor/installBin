default: build

build:
	docker pull ubuntu:16.04
	docker build -f Dockerfile --tag hamster-time-tracker:latest .
	mkdir -p $HOME/.local/share/hamster-applet
	docker run --rm -t \
		-e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v ${HOME}/.local/share/hamster-applet:/home/user/.local/share/hamster-applet \
		hamster-time-tracker:latest \
		hamster-indicator

