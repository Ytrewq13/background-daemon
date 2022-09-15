USER=`logname`

# Must be run as sudo
install:
	@echo "Copying files..."
	cp ./desktop-bg-rand.sh /usr/bin/
	cp ./set-background /usr/bin/
	cp ./desktopbackground.service /etc/systemd/user/
	@echo "Reloading systemd daemon..."
	systemctl --user -M $(USER)@ daemon-reload
	@echo "Starting/enabling systemd timer..."
	systemctl --user -M $(USER)@ enable desktopbackground.service
	systemctl --user -M $(USER)@ start desktopbackground.service
	@echo "Done"

# Must be run as user
uninstall:
	@echo "Stopping/disabling systemd timer..."
	-systemctl --user -M $(USER)@ stop desktopbackground.service
	-systemctl --user -M $(USER)@ disable desktopbackground.service
	@echo "Removing files..."
	rm -f /usr/bin/desktop-bg-rand.sh
	rm -f /usr/bin/set-background
	rm -f /etc/systemd/user/desktopbackground.service
	@echo "Done"
