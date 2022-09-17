USER=`logname`

# Must be run as sudo
install:
	@echo "Copying files..."
	cp ./desktop-bg-rand.sh /usr/bin/
	cp ./set-background /usr/bin/
	cp ./desktopbackground.service /etc/systemd/system/
	@echo "Reloading systemd daemon..."
	systemctl daemon-reload
	@echo "Starting/enabling systemd timer..."
	systemctl enable desktopbackground.service
	systemctl restart desktopbackground.service
	@echo "Done"

# Must be run as user
uninstall:
	@echo "Stopping/disabling systemd timer..."
	-systemctl stop desktopbackground.service
	-systemctl disable desktopbackground.service
	@echo "Removing files..."
	rm -f /usr/bin/desktop-bg-rand.sh
	rm -f /usr/bin/set-background
	rm -f /etc/systemd/system/desktopbackground.service
	@echo "Done"
