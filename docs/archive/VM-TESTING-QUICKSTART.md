# BlueLab VM Testing Quick Start Guide

## Ready to Test! 🚀

✅ **Pre-flight validation completed**  
✅ **Build artifacts verified**  
✅ **Testing framework prepared**

## Get the ISO

### Option 1: GitHub Releases (Recommended)
1. Go to: https://github.com/JungleJM/BlueLab/releases
2. Download the latest `bluelab-*.iso` file

### Option 2: GitHub Actions Artifacts
1. Go to: https://github.com/JungleJM/BlueLab/actions
2. Click on latest successful "Build BlueLab Image" run
3. Download artifacts (requires GitHub login)

### Option 3: Container Registry
Pull the container image and create ISO:
```bash
podman pull ghcr.io/jungljem/bluelab:latest
# Convert to ISO using your preferred method
```

## VM Setup Requirements

### Minimum Specifications
- **RAM**: 4GB
- **Disk**: 60GB
- **CPU**: 2 cores
- **Network**: NAT or Bridged (internet access required)

### Recommended Hypervisors
- VMware Workstation/Fusion
- VirtualBox
- QEMU/KVM
- Hyper-V

## Testing Scenarios (Pick One to Start)

### 🟢 Scenario 1: Minimal Test (Easiest)
**iVentoy parameters:**
```
bluelab.username=testuser bluelab.password=testpass123
```
**What it tests:** Basic first-boot flow with defaults

### 🟡 Scenario 2: Full Parameters Test
**iVentoy parameters:**
```
bluelab.username=admin bluelab.password=secure123 bluelab.hostname=bluelab-test bluelab.timezone=America/New_York bluelab.stacks=monitoring,media
```
**What it tests:** All parameter parsing and multiple stacks

### 🟠 Scenario 3: Interactive Test
**iVentoy parameters:** (none)
**What it tests:** Interactive prompts when no parameters provided

## Step-by-Step Testing

### 1. Create VM
1. Create new VM with specifications above
2. Mount BlueLab ISO as boot device
3. Configure network for internet access

### 2. Boot and Monitor
1. Start VM and boot from ISO
2. Watch for first-boot service startup
3. Monitor logs if possible: `journalctl -fu bluelab-first-boot`

### 3. Validation Checklist
During setup, verify:
- [ ] Parameters parsed correctly (or prompts appear)
- [ ] User account creation succeeds
- [ ] Network configuration completes
- [ ] Docker services deploy
- [ ] No critical errors in logs

### 4. Access Testing
After setup completes, test:
- [ ] `http://bluelab.local:3000` (Homepage)
- [ ] `http://bluelab.local:5001` (Dockge)
- [ ] Services respond correctly
- [ ] No error messages displayed

### 5. Persistence Testing
1. Reboot the VM
2. Verify:
   - [ ] Services start automatically
   - [ ] First-boot doesn't re-run
   - [ ] Web interfaces still accessible
   - [ ] Completion marker exists: `/var/lib/bluelab/.first-boot-complete`

## Expected Results

### ✅ Success Indicators
- Setup completes in under 10 minutes
- Professional completion message displayed
- Web interfaces accessible via hostname
- All services running and healthy
- System survives reboot

### ❌ Failure Indicators
- First-boot service fails or hangs
- Web interfaces not accessible
- Error messages in logs
- Services don't start after reboot
- Missing directories or files

## Troubleshooting

### Common Issues
1. **Hostname not resolving**: Try IP address instead
2. **Services not starting**: Check Docker daemon status
3. **Permission errors**: Verify user in docker group
4. **Network issues**: Ensure VM has internet access

### Log Files to Check
- `/var/log/bluelab-first-boot.log` - Main setup log
- `journalctl -u bluelab-first-boot` - systemd service log
- `docker logs <container>` - Individual service logs

## Report Results

### Success Report
If everything works:
1. Note which scenario was tested
2. Record setup time
3. Confirm all validation items passed
4. Document any minor issues or observations

### Failure Report
If issues occur:
1. Document exact error messages
2. Include relevant log file contents
3. Note which step failed
4. Record system environment details

## Next Steps After Testing

### If Tests Pass ✅
- Move to edge case testing
- Test different network configurations
- Begin real hardware testing

### If Tests Fail ❌
- Document issues for resolution
- Check for known workarounds
- Consider simpler test scenarios

---

**You're ready to begin VM testing!** Start with Scenario 1 (minimal test) for the highest chance of success.