# BlueLab homelab automation system
# https://github.com/your-username/bluelab

# Set up or reconfigure BlueLab homelab system
bluelab-setup:
    #!/usr/bin/env bash
    echo "🔧 Starting BlueLab homelab setup..."
    echo ""
    echo "This will configure your BlueLab homelab system with:"
    echo "  • Interactive credential management"
    echo "  • Service stack selection"
    echo "  • Network configuration"
    echo "  • Tailscale integration (optional)"
    echo ""
    read -p "Continue with BlueLab setup? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Nn] ]]; then
        echo "Setup cancelled."
        exit 0
    fi
    echo ""
    sudo /usr/bin/bluelab-first-boot

# Show BlueLab service status and access URLs
bluelab-status:
    #!/usr/bin/env bash
    echo "🔍 BlueLab System Status"
    echo "======================="
    echo ""
    
    # Check if first boot completed
    if [ -f "/var/lib/bluelab/.first-boot-complete" ]; then
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
    echo "First boot log:"
    if [ -f "/var/log/bluelab-first-boot.log" ]; then
        tail -20 /var/log/bluelab-first-boot.log
    else
        echo "   No first boot log found"
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