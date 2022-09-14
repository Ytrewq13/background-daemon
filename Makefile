all: build

# install must be run as root.
install: build
	cp background-daemon /usr/bin/
	cp randomize-background /usr/bin/

uninstall:
	rm /usr/bin/background-daemon
	rm /usr/bin/randomize-background

build:
	gcc -Wall main.c -o background-daemon

clean:
	rm background-daemon
