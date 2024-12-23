# Default target when you run `make`
all: setup

# Target to run all setup scripts
setup: setup-ssh-server setup-wol

# Target to set up SSH server
setup-ssh-server:
	./scripts/ssh-server/setup-ssh-server.sh

# Target to set up Wake-on-LAN
setup-wol:
	./scripts/ssh-server/setup-wol.sh

# Update duckdns IP
update-duckdns:
	./scripts/ssh-server/update-duckdns.sh

# Add duckdns cron
add-duckdns-cron:
	./scripts/ssh-server/add-duckdns-cron.sh

# Remove duckdns cron
remove-duckdns-cron:
	./scripts/ssh-server/remove-duckdns-cron.sh

setup-wireguard:
	./scripts/wireguard-vpn/setup.sh

generate-wg-client:
	./scripts/wireguard-vpn/generate-keys.sh $(client)

update-wg-config:
	./scripts/wireguard-vpn/update-wg-config.sh

# Target to clean up or reset (if needed)
clean:
	echo "No cleanup tasks defined yet!"
