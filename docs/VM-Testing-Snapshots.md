# VM Testing with Snapshots - Rapid Iteration Guide

## Quick Snapshot Workflow for BlueLab Testing

### 1. Create Base Snapshot
1. **Fresh ISO install** - Boot from BlueLab ISO
2. **Complete basic OS setup** - Get to desktop, but DON'T run first-boot script
3. **Create snapshot**: "fresh-install-ready"
4. **Test first-boot script** 
5. **If issues found**: Revert to snapshot, fix code, test again

### 2. Platform-Specific Commands

#### VMware Workstation/Player
```bash
# Create snapshot after fresh install
vmrun snapshot "BlueLab-Test.vmx" "fresh-install-ready"

# Revert for new test
vmrun revertToSnapshot "BlueLab-Test.vmx" "fresh-install-ready"

# List snapshots
vmrun listSnapshots "BlueLab-Test.vmx"
```

#### VirtualBox
```bash
# Create snapshot
vboxmanage snapshot "BlueLab-VM" take "fresh-install-ready" --description "Fresh ISO install, ready for first-boot testing"

# Restore snapshot
vboxmanage snapshot "BlueLab-VM" restore "fresh-install-ready"

# List snapshots
vboxmanage snapshot "BlueLab-VM" list
```

#### Proxmox VE
```bash
# Create snapshot
qm snapshot <vmid> fresh-install-ready --description "Fresh install ready for testing"

# Restore snapshot  
qm rollback <vmid> fresh-install-ready
```

### 3. Testing Iteration Cycle

```bash
# 1. Revert to clean state
vmrun revertToSnapshot "BlueLab-Test.vmx" "fresh-install-ready"

# 2. Start VM
vmrun start "BlueLab-Test.vmx"

# 3. Copy updated script to VM (if testing script changes)
scp files/bin/bluelab-first-boot user@vm-ip:/tmp/
ssh user@vm-ip "sudo cp /tmp/bluelab-first-boot /usr/bin/"

# 4. Test first-boot script
ssh user@vm-ip "sudo /usr/bin/bluelab-first-boot"

# 5. Test services
curl http://vm-ip:3000

# 6. If issues found: Repeat from step 1
```

### 4. Advanced: Automated Testing

Create a script to automate the cycle:

```bash
#!/bin/bash
# test-bluelab-cycle.sh

VM_PATH="BlueLab-Test.vmx"
VM_IP="192.168.1.100"  # Update with your VM IP
SNAPSHOT="fresh-install-ready"

echo "Reverting to snapshot..."
vmrun revertToSnapshot "$VM_PATH" "$SNAPSHOT"

echo "Starting VM..."
vmrun start "$VM_PATH"

echo "Waiting for VM to boot..."
sleep 30

echo "Copying updated script..."
scp files/bin/bluelab-first-boot user@$VM_IP:/tmp/

echo "Installing and running script..."
ssh user@$VM_IP "sudo cp /tmp/bluelab-first-boot /usr/bin/ && sudo /usr/bin/bluelab-first-boot"

echo "Testing services..."
curl http://$VM_IP:3000
curl http://$VM_IP:5001

echo "Test cycle complete!"
```

### 5. Snapshot Strategy by Phase

#### Phase 1 (Current)
- **Snapshot Point**: Fresh ISO install, before first-boot
- **Test Focus**: First-boot script, service deployment
- **Iteration**: Script fixes, container deployment

#### Phase 2+  
- **Snapshot Point**: After Phase 1 complete (monitoring deployed)
- **Test Focus**: Additional stack deployment
- **Iteration**: Stack templates, runtime downloads

### 6. Benefits

✅ **Fast iteration** - 30 seconds vs 10+ minutes for fresh install  
✅ **Consistent starting point** - No variables from previous tests  
✅ **Easy rollback** - Instant return to known good state  
✅ **Multiple test scenarios** - Different snapshots for different phases  

### 7. Storage Considerations

- **Disk space**: Each snapshot takes additional space
- **Cleanup**: Remove old snapshots periodically
- **Naming**: Use descriptive snapshot names with dates
- **Backup**: Keep working snapshot copies

### 8. Alternative: Container Testing

For script-only testing (faster than VMs):

```bash
# Test script logic in container
podman run -it --rm --privileged \
  -v $(pwd)/files:/tmp/bluelab \
  ghcr.io/ublue-os/bluefin-dx:41 \
  bash -c "cp /tmp/bluelab/bin/bluelab-first-boot /usr/bin/ && /usr/bin/bluelab-first-boot"
```

This approach gives you **rapid iteration cycles** while maintaining **clean testing environments**!