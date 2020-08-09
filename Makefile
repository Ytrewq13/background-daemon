all: build

# install must be run as root.
install:
	cp background-daemon /usr/bin/

build:
	gcc -Wall main.c -o background-daemon

clean:
	rm background-daemon
