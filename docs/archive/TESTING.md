# BlueLab Hardware Testing Plan

## Phase 1: VM Testing Setup

### Test Environment Requirements
- **Hypervisor**: VMware Workstation, VirtualBox, or QEMU/KVM
- **VM Specs**: 4GB RAM, 60GB disk, 2 CPUs (minimum)
- **Network**: NAT or bridged networking for internet access
- **iVentoy**: Latest version with BlueLab ISO

### Testing Checklist

#### 1. Build Verification
- [ ] Latest BlueLab image builds successfully in CI/CD
- [ ] ISO file downloads and boots properly
- [ ] First-boot service is enabled and configured

#### 2. iVentoy Parameter Testing
Test various parameter combinations:

**Minimal Parameters:**
```
bluelab.username=testuser bluelab.password=testpass123
```

**Full Parameters:**
```
bluelab.username=admin bluelab.password=secure123 bluelab.hostname=bluelab-test bluelab.timezone=America/New_York bluelab.stacks=monitoring,media bluelab.tailscale_key=tskey-auth-xxx
```

**Edge Cases:**
```
# Empty parameters (should prompt interactively)
# Invalid timezone (should fall back to UTC)
# Invalid stacks (should skip invalid ones)
# Special characters in password/username
```

#### 3. Network Configuration Testing
Test each network option:
- [ ] **Hostname Access (default)**: `http://bluelab.local:3000`
- [ ] **Static IP**: Configure static IP and verify access
- [ ] **DHCP Reservation**: Test router configuration guide
- [ ] **Accept DHCP**: Test with dynamic IP warnings

#### 4. Service Deployment Verification
- [ ] Docker daemon starts successfully
- [ ] Monitoring stack deploys (Homepage + Dockge)
- [ ] Services are accessible via web interface
- [ ] Container health checks pass
- [ ] Services survive VM reboot

#### 5. Error Scenario Testing
- [ ] Network disconnection during setup
- [ ] Invalid parameter values
- [ ] Insufficient disk space
- [ ] Docker daemon failure
- [ ] Permission errors

### Test Execution Steps

#### Pre-Test Setup
1. Download latest BlueLab ISO from CI/CD artifacts
2. Set up VM with test specifications
3. Configure iVentoy with test parameters
4. Document baseline system state

#### Test Execution
1. Boot VM from iVentoy with parameters
2. Monitor first-boot service logs: `journalctl -fu bluelab-first-boot`
3. Verify each phase completes successfully
4. Test web interface accessibility
5. Perform post-boot validation

#### Post-Test Validation
1. Check completion marker: `/var/lib/bluelab/.first-boot-complete`
2. Verify directory structure: `/var/lib/bluelab/`
3. Test service management via Dockge
4. Confirm hostname resolution
5. Validate log files for errors

### Success Criteria

#### Functional Requirements
- [ ] First-boot completes without errors
- [ ] All specified stacks deploy successfully
- [ ] Web interfaces are accessible
- [ ] System configuration matches parameters
- [ ] Services survive reboot

#### User Experience Requirements
- [ ] Setup completes in under 10 minutes
- [ ] Clear progress indication during setup
- [ ] Professional completion message
- [ ] Accessible URLs work as documented
- [ ] No technical knowledge required

### Test Reporting

#### Pass/Fail Results
Document for each test scenario:
- Parameter combination tested
- Network configuration used
- Success/failure status
- Error messages (if any)
- Performance metrics (setup time)

#### Issue Tracking
For failed tests, document:
- Exact error message
- Log file contents
- Steps to reproduce
- Proposed fix (if known)

## Phase 2: Real Hardware Testing

### Hardware Test Plan
After VM testing passes, test on:
- [ ] Intel NUC or similar mini PC
- [ ] Raspberry Pi 4 (if supported)
- [ ] Old laptop/desktop hardware
- [ ] Different network environments

### Performance Validation
- [ ] Boot time on real hardware
- [ ] Service startup performance
- [ ] Memory usage during deployment
- [ ] Disk I/O performance
- [ ] Network throughput testing

## Automated Testing Integration

### Future Test Automation
Based on manual testing results:
- Add automated tests for frequently failing scenarios
- Create VM automation scripts for regression testing
- Build test environment provisioning
- Integrate with CI/CD pipeline

### Test Data Collection
Track metrics across test runs:
- Setup completion time
- Service deployment success rate
- Resource utilization patterns
- Common failure points
- User experience feedback