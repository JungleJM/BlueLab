# BlueBuild SELinux Finalization Issue - Bug Report

## Summary
We're experiencing a persistent SELinux policy finalization failure during OSTree deployment when using BlueBuild, despite following template best practices and including all recommended SELinux packages. This appears to be related to the `semodule` command not being accessible within the bwrap environment during finalization.

## Environment
- **BlueBuild Version**: github-action@v1.8
- **Base Image**: `ghcr.io/ublue-os/bluefin-dx:41`
- **Target System**: Universal Blue (Bluefin-DX)
- **Development Tool**: Claude Code AI
- **Repository**: https://github.com/JungleJM/BlueLab

## Background
This project (BlueLab) was developed with Claude Code AI to create an automated homelab system based on Universal Blue. While we did not start by cloning the official BlueBuild template, we have since aligned our implementation with template best practices to ensure compliance.

## Issue Description
OSTree deployment consistently fails during SELinux policy finalization with the error:
```
bwrap: execvp semodule: No such file or directory
error: Finalizing deployment: Finalizing SELinux policy: failed to run semodule: Child process exited with code 1
```

This occurs despite the `semodule` command being properly packaged and available in the built image.

## Steps Taken to Resolve

### 1. Template Compliance Alignment
We have aligned our BlueBuild configuration with the official template:
- ✅ Added YAML schema declaration (`yaml-language-server: $schema=https://schema.blue-build.org/recipe-v1.json`)
- ✅ Added signing module (`- type: signing`)
- ✅ Restructured file layout to use template-standard `files/system` structure
- ✅ Simplified workflow to match template exactly
- ✅ Added proper BlueBuild matrix strategy

### 2. SELinux Package Installation
We have included all recommended SELinux packages based on Universal Blue community guidance:
```yaml
install:
  - policycoreutils                    # Core SELinux utilities
  - policycoreutils-python-utils       # Contains semodule command
  - policycoreutils-devel              # Required for Universal Blue (per forum discussion)
```

### 3. Universal Blue Community Research
Based on [Universal Blue forum discussion](https://universal-blue.discourse.group/t/selinux-policy-failure-missing-policycoreutils-devel/4925), we added `policycoreutils-devel` as it's specifically mentioned as required for SELinux policy operations on Universal Blue systems.

## Current Recipe Configuration
```yaml
---
# yaml-language-server: $schema=https://schema.blue-build.org/recipe-v1.json
name: bluelab
description: BlueLab - Automated homelab system based on Bluefin-DX
base-image: ghcr.io/ublue-os/bluefin-dx
image-version: 41

modules:
  - type: files
    files:
      - source: system
        destination: / # copies files/system/* (* means everything inside it) into your image's root folder /
        
  - type: systemd
    system:
      enabled:
        - bluelab-updater.timer
        
  - type: rpm-ostree
    install:
      - jq
      - yq
      - git
      - tree
      - gettext
      - htop
      - iotop
      - nethogs
      - variety
      - policycoreutils
      - policycoreutils-python-utils
      - policycoreutils-devel

  - type: script
    scripts:
      - setup-bluelab-environment.sh

  - type: signing # this sets up the proper policy & signing files for signed images to work fully
```

## Error Logs
```
Jun 18 15:23:47 bluefin systemd[1]: Stopping ostree-finalize-staged.service - OSTree Finalize Staged Deployment...
Jun 18 15:23:47 bluefin ostree[8251]: Finalizing staged deployment
Jun 18 15:23:49 bluefin ostree[8251]: Copying /etc changes: 23 modified, 0 removed, 90 added
Jun 18 15:23:49 bluefin ostree[8251]: Copying /etc changes: 23 modified, 0 removed, 90 added
Jun 18 15:23:49 bluefin ostree[8267]: bwrap: execvp semodule: No such file or directory
Jun 18 15:23:49 bluefin ostree[8251]: error: Finalizing deployment: Finalizing SELinux policy: failed to run semodule: Child process exited with code 1
Jun 18 15:23:49 bluefin systemd[1]: ostree-finalize-staged.service: Control process exited, code=exited, status=1/FAILURE
```

## Observations

### What Works
- ✅ BlueBuild image compilation completes successfully
- ✅ OSTree rebase downloads and stages the image correctly  
- ✅ All packages (including SELinux tools) are properly installed in the image
- ✅ Image can be inspected and shows correct package installation

### What Fails
- ❌ OSTree finalization fails when attempting to run `semodule`
- ❌ System rolls back to previous deployment
- ❌ `semodule` appears to be inaccessible within bwrap environment during finalization

## Hypothesis
It seems like there may be an environment or path issue within the bwrap container used during OSTree finalization that prevents access to the `semodule` command, even though the required packages are installed in the image.

## Request for Guidance
We understand this could potentially be an issue with our configuration that we haven't been able to identify, or it might be a limitation in how SELinux policy finalization works within BlueBuild's containerized environment. 

We would greatly appreciate any guidance on:
1. Whether this is a known issue with BlueBuild SELinux handling
2. If there are additional configuration steps we might be missing
3. Whether there's a recommended workaround or temporary fix
4. If this represents a legitimate bug that should be addressed

We're open to trying any suggested approaches and are happy to provide additional debugging information if helpful.

## Reproduction
This issue can be reproduced by:
1. Building the BlueLab image from our repository: https://github.com/JungleJM/BlueLab
2. Attempting to rebase a Universal Blue system to the built image
3. Observing the finalization failure during reboot

Thank you for your time and for the excellent BlueBuild project!

---
*This bug report was prepared with assistance from Claude Code AI as part of our automated homelab system development.*