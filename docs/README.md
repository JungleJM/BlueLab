# BlueLab Documentation

## =Ë Current Status: Phase 1 (95% Complete)

BlueLab is currently 95% complete for Phase 1 but **on hold** due to installer timing issues during the BlueBuild/BlueFin ecosystem transition. Active development has shifted to **Phase 2** in the [BlueLab Stacks repository](https://github.com/JungleJM/BlueLab-Stacks).

## =Ú Documentation Structure

### Core Documentation

| Document | Purpose | Status |
|----------|---------|--------|
| **[Main README](../README.md)** | Project overview and vision |  Current |
| **[SSH Guide](SSH-Baremetal-Guide.md)** | Remote access for testing |  Current |
| **[Development Handoff](Production/Handoff.md)** | Complete project status and technical details |  Current |

### Architecture & Design

| Document | Purpose | Status |
|----------|---------|--------|
| **[Why BlueLab?](architecture/Why%20Bluelab.md)** | Project vision and user benefits |  Current |
| **[Technical Architecture](architecture/Technical%20Architecture.md)** | Complete system specification |  Current |
| **[System Diagrams](architecture/System%20Diagrams.md)** | Visual architecture |  Current |

### Development Status

| Document | Purpose | Status |
|----------|---------|--------|
| **[Development Handoff](Production/Handoff.md)** | Comprehensive project status |  Current |
| **[Phase 1 Progress](Production/Phase1-Progress-Summary.md)** | Detailed progress tracking | =Ý Legacy |

## =§ Current Issues

### Phase 1 Boot Issues
- **Problem**: BlueLab first-boot service conflicts with GNOME Initial Setup
- **Impact**: Installer doesn't run after system installation
- **Status**: Multiple fixes attempted, core issue related to BlueBuild installer transition
- **Resolution**: On hold while BlueBuild ecosystem stabilizes

### Why Phase 2 Focus?
- Phase 1 installer issues are ecosystem-dependent 
- Phase 2 work (stack management) can proceed independently
- Better use of development time while waiting for upstream fixes

## = External Development

**Active Development**: [BlueLab Stacks Repository](https://github.com/JungleJM/BlueLab-Stacks)
- Stack system implementation
- Service discovery and integration
- Advanced management features

## =Á Archived Documentation

Historical and development documentation moved to [`archive/`](archive/) directory:
- Legacy deployment guides
- Development notes
- Testing documentation
- Learning summaries

## <¯ For Contributors

### Phase 1 (On Hold)
- Installer timing issues need BlueBuild ecosystem resolution
- Service execution and systemd integration challenges
- Welcome to investigate, but upstream dependency exists

### Phase 2 (Active)
- **Primary Repository**: [BlueLab Stacks](https://github.com/JungleJM/BlueLab-Stacks)
- Stack management system
- Service templates and orchestration
- Modern development environment

## =Ö Quick Start for Documentation

1. **Understanding BlueLab**: Start with [Why BlueLab?](architecture/Why%20Bluelab.md)
2. **Technical Details**: Review [Technical Architecture](architecture/Technical%20Architecture.md)  
3. **Current Status**: See [Development Handoff](Production/Handoff.md)
4. **Testing Setup**: Use [SSH Guide](SSH-Baremetal-Guide.md) for remote access

---

**Last Updated**: June 17, 2025  
**Status**: Phase 1 on hold, Phase 2 active in separate repository