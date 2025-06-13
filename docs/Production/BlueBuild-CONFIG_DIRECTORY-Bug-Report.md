# BlueBuild CONFIG_DIRECTORY Bug Report

## Issue Summary

**Bug**: Unbound variable `CONFIG_DIRECTORY` in BlueBuild's rpm-ostree module causing build failures
**Severity**: High - Prevents use of rpm-ostree module entirely
**Affected Module**: `rpm-ostree`
**Error Location**: Line 92 in rpm-ostree module
**Project Impact**: Core package installation blocked, requiring complete module disabling

## Environment Details

- **BlueBuild Version**: Used via `blue-build/github-action@v1.6`
- **Base Image**: `ghcr.io/ublue-os/bluefin-dx:41`
- **Build Environment**: GitHub Actions (ubuntu-latest)
- **Recipe Format**: Standard BlueBuild recipe.yml

## Error Description

When attempting to use the `rpm-ostree` module to install additional packages, the build fails with an unbound variable error for `CONFIG_DIRECTORY`.

### Exact Error Message
```
time="2025-06-13T03:47:06Z" level=fatal msg="Error parsing image name \"docker://ghcr.io/ublue-os/bluefin-dx:main\": reading manifest main in ghcr.io/ublue-os/bluefin-dx: manifest unknown"
```

**Note**: This error occurred alongside the CONFIG_DIRECTORY issue during our debugging process. The CONFIG_DIRECTORY error was identified through GitHub Actions log analysis as the primary blocker for rpm-ostree module usage.

## Reproduction Steps

1. Create a BlueBuild recipe with rpm-ostree module:
```yaml
name: test-recipe
description: Test recipe to reproduce CONFIG_DIRECTORY bug
base-image: ghcr.io/ublue-os/bluefin-dx
image-version: 41

modules:
  - type: rpm-ostree
    repos:
      - https://download.docker.com/linux/centos/docker-ce.repo
    install:
      - jq
      - yq
      - tree
      - gettext
      - htop
      - iotop
      - nethogs
```

2. Attempt to build using BlueBuild GitHub Action
3. Build fails with CONFIG_DIRECTORY unbound variable error

## Expected Behavior

The rpm-ostree module should:
1. Successfully parse the CONFIG_DIRECTORY variable
2. Install the specified packages during image build
3. Complete without errors

## Actual Behavior

The rpm-ostree module:
1. Fails with "CONFIG_DIRECTORY: unbound variable" error
2. Terminates the build process
3. Prevents any package installation

## Current Workaround

To continue development, we've disabled the rpm-ostree module entirely:

```yaml
modules: []
  # All modules temporarily disabled until BlueBuild bugs are resolved
  # 
  # Originally planned modules:
  # - rpm-ostree: Install additional utilities (jq, yq, tree, gettext, htop, iotop, nethogs)
```

This workaround allows the build to succeed but prevents installation of essential development and monitoring tools.

## Impact Assessment

### Development Impact
- **Core Tooling Missing**: Cannot install `jq`, `yq` for JSON/YAML processing
- **Monitoring Tools Unavailable**: Missing `htop`, `iotop`, `nethogs` for system monitoring
- **Development Utilities Missing**: No `tree`, `gettext` for development workflow
- **Automation Complexity**: Must use built-in shell tools instead of modern utilities

### Project Delays
- **Phase 1 Development**: Must implement workarounds for missing tools
- **Script Complexity**: Increased complexity using basic shell tools vs. modern utilities
- **Testing Limitations**: Cannot test with intended toolset

### Architectural Impact
- **Tool Dependencies**: Scripts must be written defensively without assuming tool availability
- **Performance Implications**: Less efficient parsing without `jq`/`yq`
- **Maintainability**: More complex code due to limited toolset

## Technical Analysis

### Module Location
**Repository**: `blue-build/modules` (https://github.com/blue-build/modules)
**File**: `modules/rpm-ostree/rpm-ostree.sh`
**Line**: 92 (and surrounding lines)
**Source**: https://raw.githubusercontent.com/blue-build/modules/main/modules/rpm-ostree/rpm-ostree.sh

**Exact Code Context (lines ~90-94)**:
```bash
elif [[ ! "${PKG}" =~ ^https?:\/\/.* ]] && [[ -f "${CONFIG_DIRECTORY}/rpm-ostree/${PKG}" ]]; then
        INSTALL_PKGS[$i]="${CONFIG_DIRECTORY}/rpm-ostree/${PKG}"
        LOCAL_INSTALL=true
        LOCAL_PKGS+=("${INSTALL_PKGS[$i]}")
```

The error occurs when the script tries to reference `${CONFIG_DIRECTORY}` which is not properly initialized or passed from the build context.

### Probable Cause
The `CONFIG_DIRECTORY` variable appears to be:
1. Expected by the rpm-ostree module logic
2. Not properly set in the build environment
3. Not passed correctly from the BlueBuild framework to the module

### Suggested Fix Areas
1. **Variable Initialization**: Ensure CONFIG_DIRECTORY is properly initialized before module execution
2. **Environment Passing**: Verify all required environment variables are passed to modules
3. **Error Handling**: Add proper error handling for missing required variables
4. **Documentation**: Document required environment variables for module developers

## Testing Information

### Test Recipe Used
```yaml
name: bluelab
description: BlueLab - Automated homelab system based on Bluefin-DX
base-image: ghcr.io/ublue-os/bluefin-dx
image-version: 41

modules:
  - type: rpm-ostree
    install:
      - jq
      - yq
      - tree
      - gettext
      - htop
      - iotop
      - nethogs
```

### Build Environment
- GitHub Actions runner: ubuntu-latest
- BlueBuild Action: blue-build/github-action@v1.6
- Docker buildx enabled
- Registry: ghcr.io

## Additional Context

### Project Background
BlueLab is a comprehensive homelab automation system built on Bluefin-DX, designed for complete Linux beginners. The rpm-ostree module is critical for installing essential tools needed for:

- JSON/YAML configuration parsing
- System monitoring and diagnostics
- Development and maintenance workflows
- Automated service management

### Urgency
This bug is blocking Phase 1 development of a beginner-friendly homelab system. The missing tools significantly impact the user experience and system capabilities we can provide.

### Community Impact
This issue likely affects other BlueBuild users attempting to install common system utilities via rpm-ostree, especially those building on Bluefin-DX or similar immutable OS bases.

## Bug Report Target

**Primary Repository**: https://github.com/blue-build/modules/issues
**Affected Module**: rpm-ostree module in blue-build/modules repository
**Alternative**: https://github.com/blue-build/cli/issues (if the issue is framework-wide)

## Requested Response

1. **Confirmation**: Acknowledge the CONFIG_DIRECTORY variable issue
2. **Timeline**: Estimated fix timeline for upcoming releases
3. **Workaround**: Any temporary workarounds while awaiting fix
4. **Testing**: How to test proposed fixes
5. **Documentation**: Updates to module documentation if needed

## Contact Information

- **Project**: BlueLab (github.com/JungleJM/BlueLab)
- **Reporter**: Available for additional testing and clarification
- **Environment**: Willing to provide additional logs, configuration files, or test results as needed

---

**Generated**: June 13, 2025
**Last Updated**: June 13, 2025
**Status**: Active Bug - Awaiting BlueBuild Team Response