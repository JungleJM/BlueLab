# BlueLab Technical Architecture

## Project Vision and Core Principles

### The Developer's Challenge
Create a system that transforms complex self-hosting infrastructure into a consumer-grade experience. The end user should be able to deploy a complete homelab with the same ease as installing a mobile app, while maintaining enterprise-grade capabilities under the hood.

### Design Philosophy
- **Principle of Least Surprise**: Every interaction should work exactly as a non-technical user would expect
- **Fail-Safe Defaults**: System should be secure and functional out of the box without user configuration
- **Progressive Disclosure**: Advanced features available but hidden until needed
- **Zero-Maintenance**: System maintains itself without user intervention
- **Atomic Operations**: All changes either succeed completely or roll back cleanly

## Technical Stack Overview

### Base Platform: Bluefin-DX + BlueBuild
**Why Bluefin-DX**: Provides immutable OS with automatic updates, container-first approach, and gaming optimizations
**Why BlueBuild**: Declarative image building with CI/CD integration and community ecosystem

```yaml
# Core Architecture Stack
Base OS: Fedora Silverblue (via Bluefin-DX)
Image Builder: BlueBuild
Container Runtime: Docker (not Podman - ecosystem compatibility)
Stack Management: Docker Compose + Dockge UI
Service Discovery: Traefik (future) + Homepage (current)
Configuration Management: Environment files + systemd
Update Management: rpm-ostree (system) + Watchtower (containers)
Networking: Tailscale (secure remote access)
Storage: ZFS (optional, for advanced users)
```

## Core System Architecture

### Layer 1: Immutable OS Foundation
```
┌─────────────────────────────────────────┐
│ Custom BlueLab Image (Built via BlueBuild) │
├─────────────────────────────────────────┤
│ Base: ghcr.io/ublue-os/bluefin-dx      │
│ + Docker CE                            │
│ + ZFS support                          │
│ + Tailscale                            │
│ + System utilities                     │
│ + Custom systemd services             │
└─────────────────────────────────────────┘
```

**Key Design Decisions**:
- **Immutable base**: Prevents user-induced system breakage
- **Layered approach**: Clean separation between OS and applications
- **Automatic updates**: OS updates via rpm-ostree rebase
- **Container-everything**: All applications run in containers

### Layer 2: Configuration and State Management
```
/var/lib/bluelab/                 # Persistent across updates
├── config.env                    # Global configuration
├── docker.env                    # Docker-specific environment
├── stacks/                       # Individual stack directories
│   ├── monitoring/
│   │   ├── docker-compose.yml
│   │   ├── .env
│   │   └── data/                # Persistent volumes
│   ├── media/
│   └── [other stacks]/
├── templates/                    # Stack templates for deployment
├── homepage/                     # Homepage configuration
├── backups/                      # Configuration backups
└── scripts/                      # Management scripts
```

**Critical Implementation Details**:
- **Persistent storage**: All config in `/var/lib/bluelab/` survives OS updates
- **Template system**: New stacks deployed from tested templates
- **Environment isolation**: Each stack has isolated environment variables
- **Backup strategy**: Automated configuration backups before changes

### Layer 3: Application Orchestration
```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   Dockge UI     │  │   Just Commands │  │   iVentoy Form  │
│  (Web Interface)│  │  (CLI Interface)│  │  (Initial Setup)│
└─────────┬───────┘  └─────────┬───────┘  └─────────┬───────┘
          │                    │                    │
          └──────────┬─────────────────────┬────────┘
                     │                     │
                     ▼                     ▼
            ┌─────────────────────────────────────┐
            │     Stack Management Engine         │
            │                                     │
            │ • Template Processing               │
            │ • Dependency Resolution             │
            │ • Environment Generation            │
            │ • Port Conflict Detection           │
            │ • Service Health Monitoring         │
            └─────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │ Docker Compose  │
                    │ Stack Execution │
                    └─────────────────┘
```

## First-Boot Automation Architecture

### Parameter Ingestion Pipeline
```
iVentoy Web Form → Kernel Parameters → First-Boot Script → System Configuration
```

**Implementation Strategy**:
```bash
# /etc/systemd/system/bluelab-first-boot.service
[Unit]
Description=BlueLab First Boot Configuration
After=network-online.target
Wants=network-online.target
ConditionPathExists=!/var/lib/bluelab/.first-boot-complete

[Service]
Type=oneshot
ExecStart=/usr/bin/bluelab-first-boot
RemainAfterExit=yes
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Parameter Processing Flow**:
1. **Parse `/proc/cmdline`** for BlueLab parameters
2. **Validate and sanitize** all user inputs
3. **Generate environment files** from templates
4. **Create user accounts** with proper permissions
5. **Configure networking** (Tailscale setup)
6. **Deploy selected stacks** via template instantiation
7. **Initialize Homepage** with discovered services
8. **Create completion marker** to prevent re-runs

### Robust Parameter Handling
```bash
#!/bin/bash
# Example parameter extraction
parse_bluelab_params() {
    local cmdline=$(cat /proc/cmdline)
    
    # Extract parameters with validation
    BLUELAB_NAME=$(echo "$cmdline" | grep -o 'bluelab.name=[^[:space:]]*' | cut -d= -f2)
    BLUELAB_DOMAIN=$(echo "$cmdline" | grep -o 'bluelab.domain=[^[:space:]]*' | cut -d= -f2)
    BLUELAB_STACKS=$(echo "$cmdline" | grep -o 'bluelab.stacks=[^[:space:]]*' | cut -d= -f2)
    
    # Validation with fallbacks
    BLUELAB_NAME=${BLUELAB_NAME:-"bluelab"}
    BLUELAB_DOMAIN=${BLUELAB_DOMAIN:-"local"}
    
    # Interactive fallback for missing critical parameters
    if [[ -z "$BLUELAB_ADMIN_USER" ]]; then
        read -p "Enter admin username: " BLUELAB_ADMIN_USER
    fi
}
```

## Stack Management System

### Stack Definition Architecture
Each stack is defined by a standardized structure:

```yaml
# /var/lib/bluelab/templates/media/stack.yml
name: media
description: Complete media management and streaming solution
category: entertainment
dependencies: []
conflicts: []
ports:
  - 8096    # Jellyfin
  - 8989    # Sonarr  
  - 7878    # Radarr
  - 8686    # Lidarr (if audio stack not installed)
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096"
    volumes:
      - "${BLUELAB_DATA}/media:/media"
      - "${BLUELAB_CONFIG}/jellyfin:/config"
    environment:
      - JELLYFIN_PublishedServerUrl=${BLUELAB_DOMAIN}
  # ... other services
```

**Dynamic Template Processing**:
```bash
# Template instantiation with environment substitution
deploy_stack() {
    local stack_name=$1
    local template_dir="/var/lib/bluelab/templates/${stack_name}"
    local stack_dir="/var/lib/bluelab/stacks/${stack_name}"
    
    # Create stack directory
    mkdir -p "$stack_dir"
    
    # Process templates with environment substitution
    envsubst < "$template_dir/docker-compose.yml.template" > "$stack_dir/docker-compose.yml"
    envsubst < "$template_dir/.env.template" > "$stack_dir/.env"
    
    # Deploy stack
    cd "$stack_dir"
    docker-compose up -d
    
    # Update homepage configuration
    update_homepage_config
}
```

### Port Management and Conflict Resolution
```bash
# Automatic port assignment with conflict detection
assign_ports() {
    local service_name=$1
    local preferred_port=$2
    local current_port=$preferred_port
    
    while port_in_use "$current_port"; do
        current_port=$((current_port + 1))
    done
    
    echo "$current_port"
}

port_in_use() {
    local port=$1
    ss -tuln | grep -q ":${port} " || \
    find /var/lib/bluelab/stacks -name "docker-compose.yml" -exec grep -q "${port}:" {} \;
}
```

## Just Command System Architecture

### Command Structure Philosophy
Design CLI commands that mirror GUI operations exactly:

```bash
# /usr/bin/just (enhanced)
bluelab-status() {
    echo "=== BlueLab System Status ==="
    echo "Hostname: $(hostname)"
    echo "IP Address: $(hostname -I | awk '{print $1}')"
    echo "Tailscale IP: $(tailscale ip 2>/dev/null || echo 'Not configured')"
    echo
    echo "=== Running Stacks ==="
    
    for stack_dir in /var/lib/bluelab/stacks/*/; do
        if [[ -f "$stack_dir/docker-compose.yml" ]]; then
            stack_name=$(basename "$stack_dir")
            echo -n "$stack_name: "
            if docker-compose -f "$stack_dir/docker-compose.yml" ps -q | grep -q .; then
                echo "✓ Running"
            else
                echo "✗ Stopped"
            fi
        fi
    done
}

bluelab-add-stack() {
    local stack_name=$1
    local available_stacks=(monitoring media audio photos books productivity gaming smb-share)
    
    if [[ -z "$stack_name" ]]; then
        echo "Available stacks:"
        printf '%s\n' "${available_stacks[@]}"
        read -p "Which stack would you like to install? " stack_name
    fi
    
    if [[ ! -d "/var/lib/bluelab/templates/$stack_name" ]]; then
        echo "Error: Stack '$stack_name' not found"
        return 1
    fi
    
    echo "Installing $stack_name stack..."
    deploy_stack "$stack_name"
    echo "✓ $stack_name stack installed successfully"
    echo "  Access via: http://$(hostname -I | awk '{print $1}'):$(get_stack_main_port "$stack_name")"
}
```

### Interactive Menu System
```bash
bluelab-apps() {
    while true; do
        clear
        echo "=== BlueLab Application Manager ==="
        echo "1. View installed applications"
        echo "2. Install new application"
        echo "3. Remove application"
        echo "4. Update all applications"
        echo "5. Backup configurations"
        echo "6. Return to main menu"
        
        read -p "Choose an option: " choice
        
        case $choice in
            1) show_installed_apps ;;
            2) install_app_interactive ;;
            3) remove_app_interactive ;;
            4) update_all_apps ;;
            5) backup_configurations ;;
            6) break ;;
            *) echo "Invalid option" ;;
        esac
        
        read -p "Press enter to continue..."
    done
}
```

## Homepage Integration and Service Discovery

### Dynamic Configuration Generation
```bash
generate_homepage_config() {
    local config_file="/var/lib/bluelab/homepage/config/services.yaml"
    
    cat > "$config_file" << 'EOF'
- Media:
EOF
    
    # Auto-discover running services
    for stack_dir in /var/lib/bluelab/stacks/*/; do
        if [[ -f "$stack_dir/docker-compose.yml" ]]; then
            parse_services_from_compose "$stack_dir/docker-compose.yml" >> "$config_file"
        fi
    done
    
    # Restart homepage to pick up changes
    docker-compose -f /var/lib/bluelab/stacks/monitoring/docker-compose.yml restart homepage
}

parse_services_from_compose() {
    local compose_file=$1
    
    # Extract service names and ports using yq
    yq eval '.services | to_entries | .[] | select(.value.ports != null) | {
        "name": .key,
        "port": .value.ports[0] | split(":")[0]
    }' "$compose_file" | while read -r service; do
        # Generate homepage service entry
        generate_service_entry "$service"
    done
}
```

### API Integration for Service Status
```yaml
# Homepage widget configuration with API integration
- Jellyfin:
    icon: jellyfin.png
    href: http://{{BLUELAB_IP}}:8096
    description: Media streaming server
    widget:
      type: jellyfin
      url: http://{{BLUELAB_IP}}:8096
      key: {{JELLYFIN_API_KEY}}
      
- Sonarr:
    icon: sonarr.png
    href: http://{{BLUELAB_IP}}:8989
    description: TV series management
    widget:
      type: sonarr
      url: http://{{BLUELAB_IP}}:8989
      key: {{SONARR_API_KEY}}
```

## Update Management System

### Coordinated Update Strategy
```bash
# /usr/bin/bluelab-update-manager
update_system() {
    local update_window_start=$(get_config "update.window.start")
    local update_window_days=$(get_config "update.window.days")
    
    # Check if we're in update window
    if ! in_update_window "$update_window_start" "$update_window_days"; then
        log "Not in update window, skipping updates"
        return 0
    fi
    
    log "Starting coordinated update process"
    
    # 1. Backup current configurations
    backup_configurations
    
    # 2. Update containers first (faster rollback)
    update_containers
    
    # 3. Update system if container updates successful
    if [[ $? -eq 0 ]]; then
        update_system_packages
    else
        log "Container updates failed, skipping system update"
        return 1
    fi
    
    # 4. Verify all services are healthy
    verify_service_health
    
    log "Update process completed successfully"
}
```

### Watchtower Configuration with Smart Scheduling
```yaml
# Watchtower service in monitoring stack
watchtower:
  image: containrrr/watchtower
  container_name: watchtower
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
  environment:
    - WATCHTOWER_SCHEDULE=${UPDATE_CRON_SCHEDULE}
    - WATCHTOWER_CLEANUP=true
    - WATCHTOWER_INCLUDE_STOPPED=true
    - WATCHTOWER_NOTIFICATION_URL=${NOTIFICATION_URL}
    - WATCHTOWER_ROLLING_RESTART=true
  command: --interval 3600 --cleanup
```

## Security Architecture

### Multi-Layer Security Model
```
┌─────────────────────────────────────────┐
│ Layer 4: Application Security          │
│ • Service-specific authentication      │
│ • API key management                   │
│ • Data encryption at rest             │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Layer 3: Container Security            │
│ • Non-root containers                  │
│ • Resource limits                      │
│ • Network isolation                    │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Layer 2: System Security               │
│ • Firewall configuration               │
│ • SSH hardening                        │  
│ • Automatic security updates           │
└─────────────────────────────────────────┘
┌─────────────────────────────────────────┐
│ Layer 1: Network Security              │
│ • Tailscale VPN                        │
│ • No exposed ports to internet         │
│ • Certificate management               │
└─────────────────────────────────────────┘
```

### Tailscale Integration
```bash
setup_tailscale() {
    local auth_key=$1
    
    # Install and configure Tailscale
    systemctl enable --now tailscaled
    
    if [[ -n "$auth_key" ]]; then
        tailscale up --authkey="$auth_key" --accept-routes
    else
        echo "Visit https://login.tailscale.com/ to authorize this device"
        tailscale up --accept-routes
    fi
    
    # Configure firewall to allow Tailscale
    firewall-cmd --permanent --add-interface=tailscale0
    firewall-cmd --reload
}
```

## iVentoy Integration Details

### Web Form to Kernel Parameters Mapping
```html
<!-- iVentoy template form -->
<form>
    <input name="bluelab.name" placeholder="BlueLab Name" value="bluelab">
    <input name="bluelab.domain" placeholder="Domain" value="local">
    <input name="bluelab.admin.user" placeholder="Admin Username" required>
    <input name="bluelab.admin.pass" type="password" placeholder="Admin Password" required>
    <input name="bluelab.tailscale.key" placeholder="Tailscale Auth Key">
    
    <!-- Update Schedule -->
    <select name="bluelab.update.time">
        <option value="02:00">2:00 AM</option>
        <option value="03:00">3:00 AM</option>
        <option value="04:00">4:00 AM</option>
    </select>
    
    <div>
        <input type="checkbox" name="bluelab.stacks" value="monitoring" checked disabled>
        <label>Monitoring (Required)</label>
    </div>
    <div>
        <input type="checkbox" name="bluelab.stacks" value="media">
        <label>Media Server (Jellyfin, Sonarr, Radarr)</label>
    </div>
    <!-- Additional stack checkboxes -->
</form>
```

**Parameter Conversion**:
```
Form Input: bluelab.stacks=monitoring,media,photos
Kernel Parameter: bluelab.stacks=monitoring,media,photos
Script Processing: IFS=',' read -ra STACKS <<< "$BLUELAB_STACKS"
```

## Development and CI/CD Architecture

### BlueBuild Recipe Structure
```yaml
# recipe.yml
name: bluelab
description: Automated homelab system based on Bluefin
base-image: ghcr.io/ublue-os/bluefin-dx
image-version: latest

modules:
  - type: rpm-ostree
    repos:
      - docker-ce-stable
    install:
      - docker-ce
      - docker-compose-plugin
      - zfs
      - zfs-fuse
      - samba
      - tailscale
      - jq
      - yq
      - rsync
      
  - type: systemd
    system:
      bluelab-first-boot.service: enabled
      
  - type: files
    files:
      - usr: /usr
        
  - type: script
    scripts:
      - setup-bluelab-commands.sh
```

### GitHub Actions Pipeline
```yaml
# .github/workflows/build.yml
name: Build BlueLab Image
on:
  schedule:
    - cron: '0 6 * * *'  # Daily at 6 AM UTC
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
      
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        
      - name: Build Custom Image
        uses: blue-build/github-action@v1.6
        with:
          recipe: recipe.yml
          cosign_private_key: ${{ secrets.SIGNING_SECRET }}
          registry_token: ${{ github.token }}
          pr_event_number: ${{ github.event.number }}

      - name: Test Image
        run: |
          # Test basic functionality
          podman run --rm -it ${{ env.IMAGE_NAME }} /usr/bin/just bluelab-status
```

## Error Handling and Recovery

### Graceful Degradation Strategy
```bash
# Robust service deployment with rollback
deploy_stack_safe() {
    local stack_name=$1
    local backup_dir="/var/lib/bluelab/backups/$(date +%Y%m%d_%H%M%S)"
    
    # Create backup before changes
    mkdir -p "$backup_dir"
    cp -r "/var/lib/bluelab/stacks/$stack_name" "$backup_dir/" 2>/dev/null || true
    
    # Attempt deployment
    if ! deploy_stack "$stack_name"; then
        log "Deployment failed, attempting rollback"
        
        # Rollback to previous state
        if [[ -d "$backup_dir/$stack_name" ]]; then
            rm -rf "/var/lib/bluelab/stacks/$stack_name"
            cp -r "$backup_dir/$stack_name" "/var/lib/bluelab/stacks/"
            docker-compose -f "/var/lib/bluelab/stacks/$stack_name/docker-compose.yml" up -d
        fi
        
        return 1
    fi
    
    # Verify deployment
    if ! verify_stack_health "$stack_name"; then
        log "Stack unhealthy after deployment, rolling back"
        # Rollback logic here
        return 1
    fi
    
    # Cleanup old backup
    rm -rf "$backup_dir"
    return 0
}
```

## Monitoring and Observability

### Health Check System
```bash
# Comprehensive health monitoring
check_system_health() {
    local health_status=0
    
    # Check system resources
    if [[ $(df /var/lib/bluelab | tail -1 | awk '{print $5}' | sed 's/%//') -gt 90 ]]; then
        log "WARNING: BlueLab storage >90% full"
        health_status=1
    fi
    
    # Check all stacks
    for stack_dir in /var/lib/bluelab/stacks/*/; do
        stack_name=$(basename "$stack_dir")
        if ! check_stack_health "$stack_name"; then
            log "ERROR: Stack $stack_name is unhealthy"
            health_status=1
        fi
    done
    
    # Check network connectivity
    if ! curl -s --max-time 5 https://1.1.1.1 > /dev/null; then
        log "WARNING: No internet connectivity"
        health_status=1
    fi
    
    return $health_status
}
```

## Performance Optimization Strategies

### Resource Management
```yaml
# Example resource-limited service
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
        reservations:
          memory: 512M
          cpus: '0.25'
    # Hardware acceleration for media processing
    devices:
      - /dev/dri:/dev/dri
    group_add:
      - "109"  # render group
```

### Caching and Storage Optimization
- **Container image caching**: Shared base images across stacks
- **Volume optimization**: Proper volume mounts for performance
- **ZFS integration**: Optional advanced storage with snapshots
- **Cleanup automation**: Regular cleanup of unused images and volumes

## Extension and Customization Framework

### Plugin Architecture (Future)
```bash
# Plugin discovery and loading
load_plugins() {
    local plugin_dir="/var/lib/bluelab/plugins"
    
    for plugin in "$plugin_dir"/*.sh; do
        if [[ -f "$plugin" && -x "$plugin" ]]; then
            source "$plugin"
            log "Loaded plugin: $(basename "$plugin" .sh)"
        fi
    done
}
```

This technical architecture provides the blueprint for creating a sophisticated yet user-friendly BlueLab system. The key is maintaining simplicity at the user interface level while implementing robust, enterprise-grade functionality underneath.

The architecture prioritizes reliability, automatic recovery, and progressive disclosure of complexity - exactly what's needed to serve both complete beginners and advanced users who want to customize their experience.