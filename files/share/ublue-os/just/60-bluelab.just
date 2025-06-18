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