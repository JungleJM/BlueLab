# BlueLab Testing Strategy

## Universal Blue Rebase Workflow Testing

BlueLab now follows the proper Universal Blue philosophy with a rebase workflow. Testing focuses on the core value: homelab stack management and deployment.

## Testing Philosophy

### What We Test
- **Stack Deployment Logic**: Docker Compose template generation and deployment
- **Service Integration**: Homepage configuration and service discovery
- **ujust Commands**: Interactive setup and management commands

### What We Don't Test
- ~~iVentoy Integration~~ (removed - no custom ISOs)
- ~~First-boot Automation~~ (removed - now interactive via ujust)
- ~~Parameter Parsing~~ (removed - simplified workflow)
- **System Integration**: Test manually on real systems via rebase

## Current Test Structure

### Remaining Tests
- `integration/test_stack_management.sh` - Stack deployment and management
- `unit/test_stack_deployment.sh` - Docker Compose template logic

### Manual Testing Focus
Real testing happens via the proper workflow:
1. Install standard Bluefin-DX
2. Rebase to BlueLab image
3. Run `ujust bluelab-setup`
4. Validate homelab services

## Testing Workflow

### Phase 1: Core Functionality ✅
- ✅ Rebase workflow working
- ✅ Interactive setup via ujust
- ✅ Basic stack deployment (Homepage + Dockge)

### Phase 2: Stack System (In Progress)
- Stack template system
- Multi-stack deployment
- Service discovery integration

### Manual Testing Procedure

```bash
# 1. Set up test environment
rpm-ostree rebase ostree-unverified-registry:ghcr.io/junglejm/bluelab

# 2. Test interactive setup
ujust bluelab-setup

# 3. Verify services
curl http://bluelab.local:3000  # Homepage
curl http://bluelab.local:5001  # Dockge

# 4. Test management commands
ujust bluelab-status
ujust bluelab-logs
```

## Value-Based Testing

**Focus on what matters**: The value of BlueLab is in curated homelab stacks and easy management, not installation automation. Tests should reflect this focus.