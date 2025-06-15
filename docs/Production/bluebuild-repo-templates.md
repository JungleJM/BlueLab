# BlueBuild Repository Templates

This document contains template configurations and examples from BlueBuild's official repository for reference when debugging build issues.

## Basic Recipe Template

Based on BlueBuild's official templates, here's the minimal working recipe structure:

```yaml
name: bluelab
description: BlueLab - Automated homelab system based on Bluefin-DX
base-image: ghcr.io/ublue-os/bluefin-dx
image-version: 41

modules: []
  # Start with empty modules for basic ISO generation
  # Add modules incrementally after confirming basic build works
```

## Adding Files and Scripts

When ready to add files, use this pattern:

```yaml
modules:
  - type: files
    files:
      # System files and scripts
      - source: files/
        destination: /
        
  # Only add after files module works
  - type: systemd
    system:
      enabled:
        - bluelab-first-boot.service
        - bluelab-updater.timer
```

## Package Installation

For package installation, use rpm-ostree:

```yaml
modules:
  - type: rpm-ostree
    repos:
      # Add any custom repos here
    install:
      - jq
      - yq
      - docker-compose
      # Add packages incrementally
```

## Container Setup

For Docker setup:

```yaml
modules:
  - type: containerfile
    containerfile: |
      # Install Docker
      RUN rpm-ostree install docker docker-compose
      
      # Configure Docker group
      RUN getent group docker || groupadd docker
```

## Testing Strategy

1. Start with minimal recipe (no modules)
2. Add files module only
3. Add systemd module
4. Add package installation
5. Add containerfile customizations

Each step should result in successful ISO generation before proceeding.