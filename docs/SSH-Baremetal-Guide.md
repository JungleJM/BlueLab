# Quick SSH into Test Machines

## Setup (on test machine)
```bash
sudo systemctl enable --now sshd; hostname -I
```

## Connect (from dev machine)
```bash
ssh username@192.168.50.236
```

## Debug BlueLab
```bash
# Check first boot status
ls /var/lib/bluelab/.first-boot-complete

# View logs
sudo tail /var/log/bluelab-first-boot.log

# Check containers
docker ps

# Test services
curl localhost:3000
curl localhost:5001
```

## Test Machine IPs
- **192.168.50.236** (primary test VM)