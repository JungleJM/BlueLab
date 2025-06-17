#!/bin/bash
set -euo pipefail

# Setup script that runs during BlueBuild image creation
# This only sets up things in the immutable filesystem (/usr, /etc)
# Runtime directories in /var/lib are created by first-boot script via systemd-tmpfiles

echo "Setting up BlueLab environment in image build..."

# Create marker file to indicate this is a BlueLab image with build timestamp
echo "bluelab-$(date +%Y%m%d-%H%M%S)" > /etc/bluelab-version
echo "Built from commit: $(echo "${GITHUB_SHA:-unknown}")" >> /etc/bluelab-version

# Set up logrotate for BlueLab logs (when they get created at runtime)
cat > /etc/logrotate.d/bluelab << 'EOF'
/var/log/bluelab/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

# Create systemd tmpfiles.d entry to ensure directories are created early in boot
# This runs before our first-boot service, creating the base structure
cat > /etc/tmpfiles.d/bluelab.conf << 'EOF'
# BlueLab directory structure - created early in boot process
# Type Path                           Mode UID  GID  Age Argument
d      /var/lib/bluelab                0755 root root -   -
d      /var/lib/bluelab/config         0750 root root -   -
d      /var/lib/bluelab/stacks         0755 root root -   -
d      /var/lib/bluelab/templates      0755 root root -   -
d      /var/lib/bluelab/backups        0700 root root -   -
d      /var/lib/bluelab/scripts        0755 root root -   -
d      /var/lib/bluelab/data           0755 root root -   -
d      /var/log/bluelab                0755 root root -   -
EOF

# Verify BlueBuild copied our files correctly
echo "Verifying BlueLab files in image..."
if [[ -d "/usr/share/bluelab" ]]; then
    echo "✅ BlueLab templates directory found"
    find /usr/share/bluelab -type f | head -10 | sed 's/^/  /'
else
    echo "⚠️  BlueLab templates directory not found - check BlueBuild files module"
fi

# Verify our scripts are present and executable
if [[ -f "/usr/bin/bluelab-first-boot" ]]; then
    echo "✅ First-boot script found"
    chmod +x /usr/bin/bluelab-*
else
    echo "⚠️  First-boot script not found - check BlueBuild files module"
fi

# Ensure ujust commands are available (they should be in Bluefin-DX)
if command -v ujust >/dev/null 2>&1; then
    echo "✅ ujust command available"
else
    echo "⚠️  ujust command not found - may cause issues"
fi

# Make sure all our scripts will be executable at runtime
find /usr/bin -name "bluelab-*" -type f -exec chmod +x {} \; 2>/dev/null || true
find /usr/share/bluelab/scripts -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

# Create a simple verification script that users can run
cat > /usr/bin/bluelab-verify << 'EOF'
#!/bin/bash
# BlueLab system verification script

echo "=== BlueLab System Verification ==="
echo "Version: $(cat /etc/bluelab-version 2>/dev/null || echo 'Unknown')"
echo "Templates available: $(ls /usr/share/bluelab/templates/ 2>/dev/null | wc -l)"
echo "Runtime directory: $(ls -ld /var/lib/bluelab 2>/dev/null || echo 'Not created yet')"
echo "First boot completed: $(test -f /var/lib/bluelab/.first-boot-complete && echo 'Yes' || echo 'No')"

if command -v docker >/dev/null 2>&1; then
    echo "Docker: $(docker --version 2>/dev/null || echo 'Not available')"
else
    echo "Docker: Not installed (run 'ujust toggle-devmode')"
fi

if command -v tailscale >/dev/null 2>&1; then
    echo "Tailscale: $(tailscale version 2>/dev/null || echo 'Not available')"
else
    echo "Tailscale: Not installed (run 'ujust toggle-tailscale')"
fi
EOF
chmod +x /usr/bin/bluelab-verify

# Set up ujust commands integration
if [[ -f "/usr/bin/bluelab-setup-ujust" ]]; then
    echo "Setting up BlueLab ujust commands..."
    /usr/bin/bluelab-setup-ujust
else
    echo "⚠️  bluelab-setup-ujust script not found"
fi

echo "✅ BlueLab environment setup complete in image"
echo "Image will contain:"
echo "  - Templates in /usr/share/bluelab/"
echo "  - Scripts in /usr/bin/bluelab-*"
echo "  - Services in /usr/lib/systemd/system/"
echo "  - Runtime directories created via tmpfiles.d"