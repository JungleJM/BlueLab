# Automatic Installer Configuration - Smart Drive Selection

## Overview

BlueLab should automatically install to the optimal drive and optionally set up media storage on larger drives without user intervention.

## Phase 1: Automatic Installation Target Selection

### Requirements
- **Install to smallest drive** (conserve larger drives for data)
- **Prefer NVMe over SATA** (performance optimization)
- **Minimum 64GB** for system installation
- **Skip USB/removable drives** (avoid installing to installation media)

### Implementation Strategy

This requires modifications to the **Anaconda installer** or **kickstart configuration**, not our first-boot script.

#### Option A: Kickstart Automation
```bash
# Add to kickstart configuration
%pre
#!/bin/bash

# Find smallest non-removable drive, prefer NVMe
INSTALL_DRIVE=$(lsblk -d -p -n -o NAME,SIZE,TYPE,TRAN --bytes | \
    grep "disk" | \
    grep -v "usb" | \
    sort -k4,4 -k2,2n | \
    head -n1 | \
    awk '{print $1}')

echo "ignoredisk --only-use=$INSTALL_DRIVE" > /tmp/drive-selection
%end

# Include the drive selection
%include /tmp/drive-selection
```

#### Option B: BlueBuild Modifications
Research BlueBuild capabilities for installer customization:
- Custom anaconda configurations
- Automatic partitioning schemes  
- Drive selection logic

### Drive Selection Logic
```bash
# Pseudo-code for drive selection
detect_optimal_install_drive() {
    # 1. List all non-removable block devices
    # 2. Filter out USB/removable drives
    # 3. Filter out drives < 64GB
    # 4. Sort by: NVMe first, then by size (smallest first)
    # 5. Select first drive from sorted list
    
    lsblk -d -p -n -o NAME,SIZE,TYPE,TRAN --bytes | \
        grep "disk" | \
        grep -v "usb" | \
        awk '$2 >= 68719476736' | \  # 64GB minimum
        sort -k4,4r -k2,2n | \       # NVMe first, then size
        head -n1 | \
        awk '{print $1}'
}
```

## Phase 2+: Automatic ZFS Media Drive Setup

### Requirements
- **Detect largest available drive** (excluding system drive)
- **User consent required** via questionnaire
- **ZFS pool creation** with organized datasets
- **SMB share configuration** with user credentials
- **Tailscale integration** for remote access

### User Experience Flow
```
=== Storage Configuration ===
📦 Detected drives:
  • /dev/nvme0n1 (500GB) - System drive
  • /dev/sda1 (4TB) - Available for media storage
  • /dev/sdb1 (2TB) - Available for media storage

Create a media drive from your largest drive for shared storage? [y/N]: y

✅ Will setup ZFS + SMB on /dev/sda1 (4TB)
📁 Accessible via: \\bluelab.local\media or \\bluelab\media (Tailscale)
```

### ZFS Dataset Structure
```
media/                 # Root pool
├── movies/           # Movie files
├── tv/               # TV show files  
├── music/            # Music files
├── photos/           # Photo storage
├── books/            # Ebook files
└── downloads/        # Download staging area
```

### SMB Configuration
```ini
[global]
    workgroup = WORKGROUP
    server string = BlueLab Media Server
    security = user
    map to guest = Bad User
    
[media]
    path = /media
    browseable = yes
    writable = yes
    guest ok = no
    valid users = %BLUELAB_USERNAME%
```

### Implementation Steps

1. **Drive Detection**
   ```bash
   # Find largest drive excluding system drive
   largest_drive=$(lsblk -d -p -n -o NAME,SIZE --bytes | \
       grep -v "$(findmnt -n -o SOURCE /)" | \
       sort -k2 -nr | \
       head -n1 | \
       awk '{print $1}')
   ```

2. **ZFS Pool Creation**
   ```bash
   # Create pool and datasets
   zpool create media "$largest_drive"
   zfs create media/movies
   zfs create media/tv
   zfs create media/music
   zfs create media/photos
   zfs create media/books
   zfs create media/downloads
   ```

3. **Samba Setup**
   ```bash
   # Install Samba
   dnf install -y samba samba-common-tools
   
   # Configure shares
   # Set user password  
   # Enable services
   ```

4. **Tailscale Integration**
   ```bash
   # Configure Tailscale hostname
   # Advertise SMB routes
   # Update firewall rules
   ```

## Network Access Patterns

### Local Network
- **SMB**: `\\bluelab.local\media`
- **IP-based**: `\\192.168.1.100\media`

### Remote (Tailscale)
- **Hostname**: `\\bluelab\media`
- **Direct IP**: `\\100.x.x.x\media`

## Security Considerations

1. **Drive Safety**
   - **Confirm drive is empty** before ZFS creation
   - **Warning prompts** for data destruction
   - **Backup recommendations** if existing data detected

2. **SMB Security**
   - **User authentication required** (no guest access)
   - **Same credentials as system user**
   - **Tailscale encryption** for remote access

3. **ZFS Benefits**
   - **Data integrity** with checksums
   - **Snapshot capabilities** for backups
   - **Compression** to save space
   - **Copy-on-write** protection

## Implementation Timeline

### Phase 1 (Current)
- [ ] Research BlueBuild installer customization options
- [ ] Document kickstart approach for automatic drive selection

### Phase 2 (Stack Implementation)
- [ ] Implement ZFS media drive questionnaire
- [ ] Add drive detection and validation logic
- [ ] Create ZFS pool and dataset setup
- [ ] Configure Samba with user authentication

### Phase 3 (Advanced Features)
- [ ] ZFS snapshot automation
- [ ] Remote backup integration
- [ ] Advanced SMB configurations
- [ ] Performance tuning and monitoring

## Testing Strategy

1. **Multi-drive VM testing** with various drive sizes and types
2. **NVMe preference validation**
3. **ZFS pool creation and SMB access testing**
4. **Tailscale remote access validation**
5. **Data safety and confirmation flow testing**

This automatic storage management will provide a **"homelab in a box"** experience where users get optimal drive usage without technical configuration.