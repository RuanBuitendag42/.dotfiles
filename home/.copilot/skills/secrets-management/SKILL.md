---
name: secrets-management
description: "git-crypt, SOPS, age, Bitwarden CLI integration, SSH key management, and security hardening"
---

# Secrets Management Reference

Complete reference for managing secrets in the dotfiles repo — git-crypt, SOPS + age, Bitwarden CLI, SSH keys, and security practices.

---

## git-crypt (Current Setup)

git-crypt provides transparent encryption for files in a Git repository. Files are encrypted on push and decrypted on pull/checkout — seamless workflow.

### How It Works

1. `.gitattributes` rules define which files to encrypt
2. Files are encrypted using a symmetric key
3. That key is itself encrypted with GPG keys of authorized users
4. GPG key for this repo is stored in Bitwarden

### Key Commands

| Command | Purpose |
|---------|---------|
| `git-crypt status` | Show encryption status of all files |
| `git-crypt status -e` | Show only encrypted files |
| `git-crypt lock` | Re-encrypt working tree (for sharing/security) |
| `git-crypt unlock` | Decrypt working tree (needs GPG key) |
| `git-crypt add-gpg-user KEYID` | Grant access to another GPG key |
| `git-crypt export-key /path/to/key` | Export symmetric key (DANGEROUS) |

### .gitattributes Configuration

```gitattributes
# SSH keys and configs
home/.ssh/** filter=git-crypt diff=git-crypt

# Any secrets directory
secrets/** filter=git-crypt diff=git-crypt

# Environment files with secrets
**/.env.local filter=git-crypt diff=git-crypt
**/.env.production filter=git-crypt diff=git-crypt
```

### Verifying Encryption

```bash
# Check that sensitive files are encrypted
git-crypt status | grep "encrypted"

# Ensure NO secrets are unencrypted
git-crypt status | grep "not encrypted"
# Review this output — sensitive paths should NOT appear here

# View raw encrypted content (to verify it's actually encrypted)
git show HEAD:home/.ssh/id_ed25519 | head -c 50
# Should be binary garbage, not readable text
```

---

## SOPS + age Integration

SOPS (Secrets OPerationS) encrypts specific values within YAML/JSON/ENV files. age is a modern, simple encryption tool used as the backend.

### Installation

```bash
pacman -S sops age
```

### age Key Generation

```bash
# Generate a new age keypair
age-keygen -o ~/.config/sops/age/keys.txt

# Output shows the public key:
# public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Protect the key file
chmod 600 ~/.config/sops/age/keys.txt
```

### SOPS Configuration

Create `.sops.yaml` in the repo root:

```yaml
creation_rules:
  # Encrypt secret YAML files
  - path_regex: secrets/.*\.yaml$
    age: "age1your_public_key_here"

  # Encrypt .env files
  - path_regex: \.env\..*$
    age: "age1your_public_key_here"

  # Encrypt specific config files
  - path_regex: config/sensitive/.*$
    age: "age1your_public_key_here"
```

### SOPS Usage

```bash
# Create/edit encrypted file (opens in $EDITOR)
sops secrets/myfile.yaml

# Decrypt to stdout (for piping)
sops -d secrets/myfile.yaml

# Encrypt an existing plaintext file
sops -e plainfile.yaml > secrets/encrypted.yaml

# Rotate keys
sops updatekeys secrets/myfile.yaml

# Set specific values
sops set secrets/myfile.yaml '["key"]' '"new_value"'
```

### How SOPS Encrypts

SOPS encrypts **values** but leaves **keys** visible:

```yaml
# What you see in the file (encrypted)
db_password: ENC[AES256_GCM,data:xxxxx,iv:xxxxx,tag:xxxxx]
api_key: ENC[AES256_GCM,data:xxxxx,iv:xxxxx,tag:xxxxx]
sops:
    age:
        - recipient: age1xxxxx
          enc: |
            -----BEGIN AGE ENCRYPTED FILE-----
            ...
```

This means you can see the structure and key names but not the secret values.

---

## Bitwarden CLI Integration

### Installation

```bash
yay -S bitwarden-cli
# or
npm install -g @bitwarden/cli
```

### Authentication

```bash
# Login (first time)
bw login

# Unlock vault (subsequent times)
export BW_SESSION=$(bw unlock --raw)

# Check status
bw status
```

### Storing Secrets

```bash
# Store the age private key as a secure note
bw create item '{
  "type": 2,
  "name": "sops-age-key",
  "notes": "",
  "secureNote": {"type": 0},
  "fields": [
    {"name": "key", "value": "AGE-SECRET-KEY-1...", "type": 1}
  ]
}'
```

### Retrieving Secrets

```bash
# Get a specific item
bw get item "sops-age-key"

# Get a field value
bw get item "sops-age-key" | jq -r '.fields[0].value'

# Get password for a login item
bw get password "my-service"

# Get TOTP code
bw get totp "my-service"
```

### Automation Script Pattern

```bash
#!/usr/bin/env bash
set -euo pipefail

# Unlock Bitwarden and set up SOPS
if ! bw status | grep -q '"unlocked"'; then
    echo "Unlocking Bitwarden vault..."
    BW_SESSION=$(bw unlock --raw)
    export BW_SESSION
fi

# Retrieve age key from Bitwarden for SOPS
export SOPS_AGE_KEY=$(bw get item "sops-age-key" | jq -r '.fields[0].value')

echo "SOPS ready with age key from Bitwarden"
```

---

## SSH Key Management

### Key Storage

- SSH keys live in `home/.ssh/` in the dotfiles repo
- Encrypted by git-crypt — transparent on the local machine
- Deployed to `~/.ssh/` via `make install-home`

### Key Generation

```bash
# Ed25519 (PREFERRED — fast, secure, small keys)
ssh-keygen -t ed25519 -C "ruan@machine" -f ~/.ssh/id_ed25519

# RSA (only if Ed25519 not supported)
ssh-keygen -t rsa -b 4096 -C "ruan@machine" -f ~/.ssh/id_rsa
```

### SSH Agent

```bash
# Start agent (usually auto-started by gnome-keyring or systemd)
eval $(ssh-agent -s)

# Add key
ssh-add ~/.ssh/id_ed25519

# List loaded keys
ssh-add -l

# Remove all keys
ssh-add -D
```

### SSH Config (`~/.ssh/config`)

```ssh-config
# Default settings
Host *
    AddKeysToAgent yes
    IdentitiesOnly yes
    ServerAliveInterval 60

# Proxmox cluster
Host pve1
    HostName 192.168.1.10
    User root
    IdentityFile ~/.ssh/id_ed25519_proxmox

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
```

### File Permissions (Critical)

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519       # Private key
chmod 644 ~/.ssh/id_ed25519.pub   # Public key
chmod 600 ~/.ssh/authorized_keys
```

---

## Security Hardening Practices

### Filesystem Security

```bash
# Verify SSH permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub

# Check for secrets in git history
git log --all --oneline -- '*secret*' '*key*' '*password*'

# Verify no sensitive files in unencrypted git objects
git-crypt status | grep "not encrypted"
```

### Network Security

| Tool | Purpose |
|------|---------|
| `ufw` or `nftables` | Firewall |
| `fail2ban` | Brute-force protection |
| SSH key auth only | Disable password auth |
| Non-default SSH port | Optional obscurity |

```bash
# UFW basics
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# SSH hardening (/etc/ssh/sshd_config)
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
```

### Dotfiles Security Rules

1. **NEVER commit unencrypted secrets** — always verify git-crypt coverage
2. **.gitattributes** must cover all sensitive paths:
   ```gitattributes
   home/.ssh/** filter=git-crypt diff=git-crypt
   secrets/** filter=git-crypt diff=git-crypt
   ```
3. **Verify encryption** before pushing: `git-crypt status -e`
4. **Rotate keys** periodically — generate new SSH/age keys yearly
5. **Passphrase on all keys** — stored in gnome-keyring for convenience

---

## Agent Rules

When agents work with secrets, these rules are **mandatory**:

1. **NEVER** print, log, or display the contents of private keys
2. **NEVER** modify git-crypt encrypted files without understanding the impact
3. **NEVER** commit changes to encrypted files without verifying git-crypt is unlocked
4. **ALWAYS** check `git-crypt status` before editing sensitive files
5. **ALWAYS** confirm with the user before any security-related operation
6. **ALWAYS** use environment variables for secrets in scripts, never hardcoded values
7. **NEVER** store secrets in plain text files, shell history, or log output
8. **NEVER** expose key material in error messages or debug output

---

## Quick Reference

### Where Secrets Live

| Secret | Storage | Encrypted By |
|--------|---------|-------------|
| SSH private keys | `home/.ssh/` in dotfiles | git-crypt |
| GPG keys | Bitwarden | Bitwarden vault |
| age private key | Bitwarden + `~/.config/sops/age/` | Bitwarden, file permissions |
| API tokens | SOPS-encrypted YAML | SOPS + age |
| Service passwords | Bitwarden | Bitwarden vault |
| git-crypt key | GPG-encrypted in `.git/` | GPG |

### Emergency Procedures

**If a secret is accidentally committed in plain text:**
1. Immediately rotate the secret (generate new key/password)
2. Use `git filter-branch` or BFG Repo Cleaner to remove from history
3. Force push (after confirming with team)
4. Verify the old secret is revoked everywhere
