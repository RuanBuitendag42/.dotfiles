# Default target when you run `make`
all: setup

# Target to run all setup scripts
setup: setup-ssh-server setup-wol

# Target to set up SSH server
setup-ssh-server:
	./scripts/setup-ssh-server.sh

# Target to set up Wake-on-LAN
setup-wol:
	./scripts/setup-wol.sh

# Target to clean up or reset (if needed)
clean:
	echo "No cleanup tasks defined yet!"
