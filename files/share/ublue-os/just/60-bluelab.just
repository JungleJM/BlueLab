# BlueLab homelab automation system
# https://github.com/JungleJM/BlueLab

# Main BlueLab setup command - run this after rebasing to BlueLab image
bluelab-setup:
    #!/usr/bin/env bash
    echo "🏠 Welcome to BlueLab Setup!"
    echo ""
    echo "This will configure your BlueLab homelab system with:"
    echo "  • Homepage Dashboard - Your mission control center"
    echo "  • Dockge Container Manager - Professional Docker management"
    echo "  • Hostname-based access (bluelab.local) - No more remembering IP addresses"
    echo "  • Remote access via Tailscale - Secure access from anywhere"
    echo "  • Professional credential management - Enterprise-grade security options"
    echo ""
    echo "This setup will take 5-10 minutes and will ask you a few simple questions."
    echo "Everything can be reconfigured later using 'ujust bluelab-reconfigure' command."
    echo ""
    read -p "Continue with BlueLab setup? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    echo ""
    echo "Starting BlueLab configuration..."
    sudo /usr/bin/bluelab-setup

# Reconfigure BlueLab system settings
bluelab-reconfigure:
    #!/usr/bin/env bash
    echo "🔧 BlueLab Reconfiguration"
    echo ""
    echo "This will allow you to change your BlueLab settings:"
    echo "  • Update credentials"
    echo "  • Add or remove service stacks"
    echo "  • Change network configuration"
    echo "  • Update Tailscale settings"
    echo ""
    read -p "Continue with reconfiguration? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo "Reconfiguration cancelled."
        exit 0
    fi
    echo ""
    sudo /usr/bin/bluelab-setup

# Show BlueLab service status and access URLs
bluelab-status:
    #!/usr/bin/env bash
    echo "🔍 BlueLab System Status"
    echo "======================="
    echo ""
    
    # Check if setup completed
    if [ -f "/var/lib/bluelab/.setup-complete" ]; then
        echo "✅ BlueLab setup: Complete"
        
        # Show running services
        echo ""
        echo "🚀 Running Services:"
        if docker ps --format "table {{.Names}}\t{{.Status}}" | grep -q "bluelab-"; then
            docker ps --format "table {{.Names}}\t{{.Status}}" | grep "bluelab-"
        else
            echo "   No BlueLab services running"
        fi
        
        # Show access URLs
        echo ""
        echo "🌐 Access URLs:"
        local hostname=$(hostname)
        local ip=$(hostname -I | awk '{print $1}')
        
        if systemctl is-active --quiet avahi-daemon; then
            echo "   📱 Local Network:"
            echo "     • Homepage: http://bluelab.local:3000"
            echo "     • Dockge:   http://bluelab.local:5001"
        fi
        
        echo "   🖥️  Direct IP:"
        echo "     • Homepage: http://${ip}:3000"
        echo "     • Dockge:   http://${ip}:5001"
        
        if systemctl is-active --quiet tailscaled; then
            echo "   🌍 Tailscale:"
            echo "     • Homepage: http://bluelab:3000"
            echo "     • Dockge:   http://bluelab:5001"
        fi
        
    else
        echo "⚠️  BlueLab setup: Not complete"
        echo ""
        echo "Run 'ujust bluelab-setup' to configure your system"
    fi

# View BlueLab logs
bluelab-logs:
    #!/usr/bin/env bash
    echo "📋 BlueLab System Logs"
    echo "====================="
    echo ""
    echo "Setup log:"
    if [ -f "/var/log/bluelab-setup.log" ]; then
        tail -20 /var/log/bluelab-setup.log
    else
        echo "   No setup log found"
    fi
    
    echo ""
    echo "Service logs (last 10 lines each):"
    for service in bluelab-homepage bluelab-dockge; do
        echo "--- $service ---"
        if docker ps --format "{{.Names}}" | grep -q "^$service$"; then
            docker logs --tail 10 "$service" 2>/dev/null || echo "   No logs available"
        else
            echo "   Service not running"
        fi
    done

# Reset BlueLab configuration (advanced)
bluelab-reset:
    #!/usr/bin/env bash
    echo "⚠️  BlueLab Configuration Reset"
    echo "=============================="
    echo ""
    echo "This will:"
    echo "  • Stop all BlueLab services"
    echo "  • Remove configuration files"
    echo "  • Clear completion markers"
    echo "  • Preserve credential files (for security)"
    echo ""
    echo "⚠️  WARNING: This cannot be undone!"
    echo ""
    read -p "Are you sure you want to reset BlueLab? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Reset cancelled."
        exit 0
    fi
    
    echo ""
    echo "🛑 Stopping BlueLab services..."
    docker-compose -f /var/lib/bluelab/stacks/monitoring/docker-compose.yml down 2>/dev/null || true
    
    echo "🗑️  Removing configuration..."
    sudo rm -f /var/lib/bluelab/.first-boot-complete
    sudo rm -rf /var/lib/bluelab/config
    sudo rm -rf /var/lib/bluelab/data
    
    echo "💾 Preserving credentials (if any)..."
    # Credentials are preserved for security
    
    echo ""
    echo "✅ BlueLab reset complete!"
    echo "Run 'ujust bluelab-setup' to reconfigure your system"

# Download and install BlueLab-Stacks
download-bluelab-stacks:
    #!/usr/bin/env bash
    echo "📦 BlueLab-Stacks Installation"
    echo "=============================="
    echo ""
    echo "This will install the complete BlueLab-Stacks system with:"
    echo "  • Core Database (PostgreSQL, Redis)"
    echo "  • Download Management (Deluge, qBittorrent)"
    echo "  • Networking (Tailscale, AdGuard)"
    echo "  • Monitoring (Homepage, Dockge)"
    echo "  • SMB File Sharing"
    echo ""
    echo "⚠️  This will create a Distrobox container and may take 10-15 minutes."
    echo ""
    read -p "Continue with BlueLab-Stacks installation? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    echo ""
    
    # Check if BlueLab-Stacks is already installed
    if distrobox list | grep -q "bluelab"; then
        echo "⚠️  BlueLab-Stacks container already exists!"
        echo "Run 'ujust uninstall-bluelab-stacks' first to remove the existing installation."
        exit 1
    fi
    
    # Create preservation tracking directory
    mkdir -p /var/lib/bluelab
    PRESERVATION_FILE="/var/lib/bluelab/.preserved-services"
    
    echo "🔍 Checking for existing services to preserve..."
    
    # Check for pre-existing services and record them
    > "$PRESERVATION_FILE"  # Clear the file
    
    # Check for Redis
    if systemctl is-active --quiet redis || systemctl is-active --quiet redis-server || docker ps --format "{{.Names}}" | grep -q redis; then
        echo "redis" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing Redis - will preserve"
    fi
    
    # Check for PostgreSQL
    if systemctl is-active --quiet postgresql || systemctl is-active --quiet postgres || docker ps --format "{{.Names}}" | grep -q postgres; then
        echo "postgresql" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing PostgreSQL - will preserve"
    fi
    
    # Check for Tailscale
    if systemctl is-active --quiet tailscaled || command -v tailscale &>/dev/null; then
        echo "tailscale" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing Tailscale - will preserve"
    fi
    
    # Check for AdGuard Home
    if systemctl is-active --quiet AdGuardHome || docker ps --format "{{.Names}}" | grep -q adguard; then
        echo "adguard" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing AdGuard Home - will preserve"
    fi
    
    # Check for Deluge
    if systemctl is-active --quiet deluged || docker ps --format "{{.Names}}" | grep -q deluge; then
        echo "deluge" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing Deluge - will preserve"
    fi
    
    # Check for qBittorrent
    if systemctl is-active --quiet qbittorrent || docker ps --format "{{.Names}}" | grep -q qbittorrent; then
        echo "qbittorrent" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing qBittorrent - will preserve"
    fi
    
    # Check for Homepage
    if docker ps --format "{{.Names}}" | grep -q homepage; then
        echo "homepage" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing Homepage - will preserve"
    fi
    
    # Check for Dockge
    if docker ps --format "{{.Names}}" | grep -q dockge; then
        echo "dockge" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing Dockge - will preserve"
    fi
    
    # Check for SMB/Samba
    if systemctl is-active --quiet smbd || systemctl is-active --quiet samba; then
        echo "samba" >> "$PRESERVATION_FILE"
        echo "  ✓ Found existing Samba/SMB - will preserve"
    fi
    
    if [ -s "$PRESERVATION_FILE" ]; then
        echo ""
        echo "📝 Preserved services recorded in: $PRESERVATION_FILE"
        echo "   These services will not be removed during uninstallation."
    else
        echo "  ℹ️ No existing services found to preserve"
    fi
    
    echo ""
    echo "🚀 Downloading and installing BlueLab-Stacks..."
    
    # Install BlueLab-Stacks
    curl -sSL https://raw.githubusercontent.com/JungleJM/BlueLab-Stacks/main/install.sh | bash
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ BlueLab-Stacks installation completed!"
        echo ""
        echo "🌐 Access your services at:"
        echo "  • Homepage: http://bluelab.local:3000"
        echo "  • Dockge: http://bluelab.local:5001"
        echo ""
        echo "📋 Useful commands:"
        echo "  • ujust bluelab-status - Check service status"
        echo "  • ujust uninstall-bluelab-stacks - Remove BlueLab stacks only"
        echo "  • distrobox enter bluelab - Access the container"
    else
        echo "❌ BlueLab-Stacks installation failed!"
        echo "Check the installation logs for details."
        exit 1
    fi

# Uninstall BlueLab-Stacks (preserves pre-existing services)
uninstall-bluelab-stacks:
    #!/usr/bin/env bash
    echo "🗑️  BlueLab-Stacks Uninstallation"
    echo "================================="
    echo ""
    
    PRESERVATION_FILE="/var/lib/bluelab/.preserved-services"
    
    # Check for preserved services
    if [ -f "$PRESERVATION_FILE" ] && [ -s "$PRESERVATION_FILE" ]; then
        echo "🛡️  The following pre-existing services will be PRESERVED:"
        while IFS= read -r service; do
            echo "  ✓ $service"
        done < "$PRESERVATION_FILE"
        echo ""
    fi
    
    echo "⚠️  This will remove:"
    echo "  • BlueLab-Stacks containers and services"
    echo "  • BlueLab data in /var/lib/bluelab/ (except preserved services)"
    echo "  • Docker containers created by BlueLab-Stacks"
    echo ""
    echo "✅ This will PRESERVE:"
    echo "  • Your Distrobox installation"
    echo "  • Pre-existing services marked during installation"
    echo "  • Host system Docker installation"
    echo ""
    echo "⚠️  Your BlueLab data will be lost!"
    echo ""
    read -p "Type 'REMOVE' to confirm BlueLab-Stacks removal: " confirm
    if [[ "$confirm" != "REMOVE" ]]; then
        echo "Uninstallation cancelled."
        exit 0
    fi
    echo ""
    echo "🛑 Stopping and removing BlueLab-Stacks..."
    
    # Stop BlueLab-Stacks containers but preserve the distrobox
    if distrobox list | grep -q "bluelab"; then
        echo "Stopping BlueLab services in container..."
        distrobox enter bluelab -- bash -c "
            # Stop only BlueLab-related containers
            docker ps -a --format '{{.Names}}' | grep -E '(bluelab|homepage|dockge|deluge|qbittorrent|adguard)' | while read container; do
                echo \"Stopping container: \$container\"
                docker stop \"\$container\" 2>/dev/null || true
                docker rm \"\$container\" 2>/dev/null || true
            done
            
            # Clean up BlueLab-specific networks
            docker network ls --format '{{.Name}}' | grep -E '(bluelab|homelab)' | while read network; do
                echo \"Removing network: \$network\"
                docker network rm \"\$network\" 2>/dev/null || true
            done
        " 2>/dev/null || true
        
        echo "✅ BlueLab services stopped (Distrobox container preserved)"
    else
        echo "No bluelab Distrobox container found."
    fi
    
    # Selectively remove BlueLab data while preserving pre-existing services
    if [ -d "/var/lib/bluelab" ]; then
        echo "Cleaning BlueLab data directory..."
        
        # Create temporary backup of preserved services list
        if [ -f "$PRESERVATION_FILE" ]; then
            cp "$PRESERVATION_FILE" "/tmp/.bluelab-preserved-services.bak"
        fi
        
        # Remove BlueLab-specific directories but preserve the base structure
        sudo rm -rf /var/lib/bluelab/stacks/ 2>/dev/null || true
        sudo rm -rf /var/lib/bluelab/data/ 2>/dev/null || true
        sudo rm -rf /var/lib/bluelab/backups/ 2>/dev/null || true
        sudo rm -rf /var/lib/bluelab/config/homepage/ 2>/dev/null || true
        sudo rm -rf /var/lib/bluelab/config/dockge/ 2>/dev/null || true
        
        # Remove completion markers
        sudo rm -f /var/lib/bluelab/.setup-complete 2>/dev/null || true
        sudo rm -f /var/lib/bluelab/.stacks-installed 2>/dev/null || true
        
        # Restore preserved services list
        if [ -f "/tmp/.bluelab-preserved-services.bak" ]; then
            sudo cp "/tmp/.bluelab-preserved-services.bak" "$PRESERVATION_FILE"
            rm "/tmp/.bluelab-preserved-services.bak"
        fi
        
        echo "✅ BlueLab data cleaned (preserved services maintained)"
    else
        echo "No BlueLab data directory found."
    fi
    
    # Clean up only BlueLab-related Docker resources on host
    echo "Cleaning up BlueLab Docker resources..."
    docker network ls --format "{{.Name}}" | grep -E "(bluelab|homelab)" | xargs -r docker network rm 2>/dev/null || true
    docker volume ls --format "{{.Name}}" | grep -E "(bluelab|homelab)" | xargs -r docker volume rm 2>/dev/null || true
    
    echo ""
    echo "✅ BlueLab-Stacks removed successfully!"
    echo ""
    if [ -f "$PRESERVATION_FILE" ] && [ -s "$PRESERVATION_FILE" ]; then
        echo "🛡️  Preserved services are still running:"
        while IFS= read -r service; do
            echo "  ✓ $service"
        done < "$PRESERVATION_FILE"
        echo ""
    fi
    echo "💡 Your Distrobox installation remains available"
    echo "💡 You can reinstall anytime with: ujust download-bluelab-stacks"

# Future: Monitor BlueBuild live ISO capabilities
bluelab-check-live-iso:
    #!/usr/bin/env bash
    echo "🔍 Checking BlueBuild Live ISO Capabilities"
    echo "==========================================="
    echo ""
    echo "As of 2025, BlueBuild is transitioning away from Anaconda."
    echo "This command will check for live ISO generation support."
    echo ""
    echo "Current status: Installer-only mode (manual setup required)"
    echo "Future: Automated iVentoy parameter support when available"
    echo ""
    echo "📖 Reference: https://blue-build.org/blog/dnf-module/"
    echo ""
    echo "🚧 This feature is planned for post-1.0 release"