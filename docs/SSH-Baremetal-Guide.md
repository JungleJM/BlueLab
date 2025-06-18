# Quick SSH into Test Machines

## Setup (on test machine)
```bash
sudo systemctl enable --now sshd; hostname -I
```

## Connect (from dev machine)
```bash
ssh username@IP_ADDRESS
```

## Test BlueLab Rebase Workflow
```bash
# Rebase to BlueLab
rpm-ostree rebase ostree-unverified-registry:ghcr.io/junglejm/bluelab
sudo systemctl reboot

# After reboot, run setup
ujust bluelab-setup

# Check setup status
ls /var/lib/bluelab/.setup-complete

# View logs
sudo tail /var/log/bluelab-setup.log

# Check containers
docker ps

# Test services
curl http://bluelab.local:3000
curl http://bluelab.local:5001
```

## Useful Commands
```bash
# Check BlueLab status
ujust bluelab-status

# View all logs
ujust bluelab-logs

# Reconfigure if needed
ujust bluelab-reconfigure
```