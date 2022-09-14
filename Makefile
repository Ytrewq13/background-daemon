# install must be run as root.
install:
	@echo "Copying executable files..."
	cp ./desktop-bg-rand.sh /usr/bin
	cp ./set-background /usr/bin
	@echo "Copying systemd unit files..."
	cp ./desktopbackground.service /etc/systemd/user/
	cp ./desktopbackground.timer /etc/systemd/user/
	@echo "Reloading systemd daemon..."
	systemctl daemon-reload

enable:
	systemctl --user enable desktopbackground.timer
	systemctl --user start desktopbackground.timer

disable:
	@echo "Stopping/disabling systemd timer..."
	-systemctl --user stop desktopbackground.timer
	-systemctl --user disable desktopbackground.service

uninstall:
	@echo "Removing systemd unit files..."
	rm /etc/systemd/user/desktopbackground.timer
	rm /etc/systemd/user/desktopbackground.service
	@echo "Removing executable files..."
	rm /usr/bin/set-background
	rm /usr/bin/desktop-bg-rand.sh
	@echo "Done"
