# BlueLab Testing Strategy

## Implementation-First, Test-Where-It-Hurts Approach

Based on lessons learned during initial development, BlueLab has adopted a targeted testing strategy optimized for infrastructure automation projects.

## Testing Philosophy

### What We Test
- **Pure Logic**: Parameter parsing, template generation, data transformation
- **Critical Integrations**: Components that break frequently or are hard to debug
- **User-Facing APIs**: Command interfaces and configuration validation

### What We Don't Test
- **One-time Setup Scripts**: First-boot configuration, directory creation
- **Hardware Integration**: Docker setup, systemd service management
- **Simple File Operations**: Configuration file generation, template copying

## Current Test Structure

### Stub Tests (For CI/CD Compatibility)
- `run_all_tests.sh` - Test runner that supports unit/integration categories
- `unit/` - Placeholder unit tests for future targeted testing
- `integration/` - Placeholder integration tests for end-to-end flows

### Manual Testing Focus
Real testing happens on target hardware:
- VM deployments with iVentoy
- Docker stack deployments  
- Service integration validation
- Performance testing on minimum hardware

## When to Add Tests

### Add Automated Tests For:
1. **Parameter Parsing Logic** - Complex string parsing that fails silently
2. **Template Generation** - Data transformation with many edge cases
3. **Port Conflict Detection** - Logic that prevents deployment issues
4. **Dependency Resolution** - Complex algorithms with multiple inputs

### Skip Automated Tests For:
1. **System Integration** - Test manually on real hardware
2. **Service Configuration** - Verify through actual service deployment
3. **Network Setup** - Validate through end-to-end testing
4. **File System Operations** - Test through normal usage

## Testing Workflow

### Phase 1: Implementation Focus
- Build core functionality manually
- Test on real hardware/VMs
- Document manual testing procedures

### Phase 2: Targeted Test Addition
- Identify pain points from Phase 1
- Add tests for components that break frequently
- Focus on logic that's hard to debug manually

### Phase 3: Integration Testing
- Add automated tests for critical end-to-end flows
- Build test environments that mirror production
- Automate deployment verification

## Manual Testing Procedures

### Basic Functionality Test
1. Build BlueLab image
2. Deploy to test VM via iVentoy
3. Verify first-boot completion
4. Check service deployment
5. Validate web interfaces

### Parameter Parsing Test
1. Test various iVentoy parameter combinations
2. Verify fallback to interactive prompts
3. Check error handling for invalid inputs
4. Validate environment file generation

### Stack Deployment Test
1. Deploy each available stack
2. Verify port assignments
3. Check service health
4. Test stack removal
5. Validate Homepage integration

## Lessons Learned

**Infrastructure projects benefit more from working prototypes and manual validation than comprehensive test suites.**

This approach allows rapid development while ensuring quality through targeted testing where it provides the most value.