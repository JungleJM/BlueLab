# BlueLab Technical Decisions & Challenges

This document tracks architectural decisions, anticipated challenges, and lessons learned throughout BlueLab's development phases. NOTE: Much of this was written by Claude.AI

## Architectural Decision Records (ADRs)

### ADR-001: Base Operating System Selection
**Status**: Accepted  
**Date**: 2025-06-12  
**Decision**: Use Bluefin-DX as base image instead of vanilla Fedora Silverblue

**Context**: Need immutable OS with container-first approach and gaming capabilities

**Options Considered**:
- Vanilla Fedora Silverblue
- Universal Blue base images
- Bluefin-DX (gaming-optimized)

**Decision**: Bluefin-DX
**Rationale**: 
- Provides immutable foundation with automatic updates
- Gaming optimizations valuable for dual-purpose systems
- Strong community and documentation
- Container-first philosophy aligns with our architecture

**Consequences**:
- Positive: Automatic updates, gaming support, proven stability
- Negative: Dependency on Universal Blue project, less control over base system

---

### ADR-002: Container Runtime Selection
**Status**: Accepted  
**Date**: 2025-06-12  
**Decision**: Use Docker instead of Podman

**Context**: Need container runtime that maximizes compatibility with homelab applications

**Options Considered**:
- Podman (Bluefin default)
- Docker CE
- Containerd

**Decision**: Docker CE
**Rationale**:
- Better ecosystem compatibility for homelab apps
- Simpler for beginners (Docker Compose widely documented)
- Most homelab tutorials use Docker
- Industry standard for self-hosting community

**Consequences**:
- Positive: Better compatibility, easier onboarding, more resources
- Negative: Less "cloud-native", requires daemon, security considerations

---

### ADR-003: Configuration Storage Location
**Status**: Accepted  
**Date**: 2025-06-12  
**Decision**: Store all configurations in `/var/lib/bluelab/`

**Context**: Need persistent storage that survives OS updates

**Options Considered**:
- `/home/user/.config/bluelab/`
- `/opt/bluelab/`
- `/var/lib/bluelab/`
- `/etc/bluelab/`

**Decision**: `/var/lib/bluelab/`
**Rationale**:
- Survives rpm-ostree updates
- FHS-compliant for service data
- Proper permissions model
- Standard location for persistent service data

**Consequences**:
- Positive: Survives updates, proper permissions, standard compliance
- Negative: Requires root for some operations, backup complexity

---

### ADR-004: Update Strategy
**Status**: Accepted  
**Date**: 2025-06-12  
**Decision**: User-defined maintenance windows for coordinated updates

**Context**: Balance between security/features and system availability

**Options Considered**:
- Always auto-update immediately
- Manual updates only
- User-defined maintenance windows
- Smart update detection (low usage periods)

**Decision**: User-defined maintenance windows
**Rationale**:
- Prevents disruption during active use
- User maintains control over timing
- Balances security with availability
- Simple to understand and configure

**Consequences**:
- Positive: No unexpected downtime, user control
- Negative: More complex implementation, potential delayed security updates

---

### ADR-005: Stack Management Approach
**Status**: Accepted  
**Date**: 2025-06-12  
**Decision**: Template-based stack deployment with dependency resolution

**Context**: Need modular, maintainable way to deploy application groups

**Options Considered**:
- Monolithic docker-compose file
- Individual container management
- Template-based stacks
- Kubernetes-style manifests

**Decision**: Template-based stacks
**Rationale**:
- Modular and maintainable
- Allows customization per deployment
- Handles dependencies cleanly
- Familiar to Docker Compose users

**Consequences**:
- Positive: Flexibility, maintainability, user choice
- Negative: Additional complexity, template management overhead

## Phase 1 Challenges & Learnings

### Anticipated Challenges (Pre-Development)

#### Challenge 1: BlueBuild Recipe Complexity
**Risk Level**: Medium  
**Description**: Creating recipe that properly inherits from Bluefin-DX while adding necessary packages without conflicts

**Mitigation Strategy**:
- Start with minimal recipe additions
- Test each package addition individually
- Use Bluefin community resources
- Implement proper CI/CD testing

**Status**: Pending Phase 1 Development

---

#### Challenge 2: iVentoy Parameter Handling
**Risk Level**: High  
**Description**: Reliably parsing and validating kernel parameters from iVentoy web forms

**Mitigation Strategy**:
- Robust parameter parsing with extensive error handling
- Fallback to interactive prompts for missing/invalid parameters
- Test with various parameter combinations
- Clear parameter format documentation

**Status**: Pending Phase 1 Development

---

#### Challenge 3: First-Boot Service Orchestration
**Risk Level**: High  
**Description**: Ensuring all first-boot configurations run in correct order and handle failures gracefully

**Mitigation Strategy**:
- Use systemd service dependencies properly
- Comprehensive logging for debugging
- Rollback mechanisms for failed configurations
- Extensive testing on clean systems

**Status**: Pending Phase 1 Development

---

#### Challenge 4: Docker Integration in OSTree
**Risk Level**: Medium  
**Description**: Docker setup and permission management in OSTree-based system

**Mitigation Strategy**:
- Follow Bluefin patterns for container runtime setup
- Use proper user groups and permissions
- Test container functionality thoroughly
- Document Bluefin-specific considerations

**Status**: Pending Phase 1 Development

---

#### Challenge 5: Update Coordination Complexity
**Risk Level**: Medium  
**Description**: Coordinating system updates (rpm-ostree) with container updates (Watchtower) based on user-defined windows

**Mitigation Strategy**:
- Design simple but flexible scheduling system
- Use systemd timers for reliable scheduling
- Implement proper locking to prevent conflicts
- Clear user feedback on update status

**Status**: Pending Phase 1 Development

---

#### Challenge 6: Directory Structure and Permissions
**Risk Level**: Low  
**Description**: Setting up proper directory structure with correct permissions for containers and system services

**Mitigation Strategy**:
- Design clear directory hierarchy early
- Use consistent permission patterns
- Test with non-root user scenarios
- Document permission requirements clearly

**Status**: Pending Phase 1 Development

---

#### Challenge 7: Monitoring Stack Integration
**Risk Level**: Medium  
**Description**: Configuring Prometheus, Grafana, and other monitoring tools to work together seamlessly

**Mitigation Strategy**:
- Use proven Docker Compose configurations
- Start with minimal monitoring setup
- Add complexity incrementally
- Test each integration thoroughly

**Status**: Pending Phase 1 Development

### Actual Challenges Encountered (Post-Development)

#### Challenge 1-A: Test-Driven Development Overhead
**Status**: Resolved  
**Date**: 2025-06-12  
**Description**: Initial approach attempted comprehensive TDD with unit tests, integration tests, and complex test infrastructure before implementing core functionality.

**Root Cause**: 
- Infrastructure automation projects differ fundamentally from application development
- TDD assumptions (rapid feedback loops, isolated units) don't apply to system integration work
- Testing systemd services, Docker containers, and hardware integration requires real environments, not mocks
- Early-stage development needs rapid prototyping, not comprehensive test coverage

**Problems Encountered**:
- GitHub Actions failures from empty test files blocking development
- Significant time spent on test infrastructure instead of core features
- Unbound variable errors in test scripts causing CI/CD failures
- Test complexity exceeding implementation complexity
- Tests providing no real confidence in system functionality

**Solution Implemented**:
- **Pivoted to Implementation-First Approach**: Focus on getting basic functionality working manually
- **Simplified Test Infrastructure**: Replaced comprehensive test suite with minimal stubs for CI/CD compatibility
- **Targeted Testing Strategy**: Plan to add tests only for critical parsing logic and frequently-broken components
- **Manual Integration Testing**: Emphasize testing on real hardware/VMs where it matters

**Key Insight**: **TDD should be applied selectively based on project characteristics**
- **Good for TDD**: Pure logic, algorithms, data transformation, API interfaces
- **Poor for TDD**: System integration, hardware interaction, service orchestration, infrastructure automation
- **Infrastructure projects benefit more from**: Working prototypes → Manual testing → Targeted tests for pain points

**Future Impact**: 
- Adopt "Implementation-First, Test-Where-It-Hurts" approach
- Prioritize manual testing on target environments
- Add automated tests for:
  - iVentoy parameter parsing (pure logic)
  - Template generation (data transformation)  
  - Critical integration flows (after they work manually)
- Skip comprehensive testing for:
  - One-time setup scripts
  - Simple configuration file generation
  - Hardware-dependent functionality

**Documentation Impact**: 
- Updated development methodology in project docs
- Simplified test requirements for contributors
- Emphasized manual testing procedures in deployment guides

---

#### Challenge 1-B: Empty File Execution Issues  
**Status**: Resolved  
**Date**: 2025-06-12  
**Description**: BlueBuild attempted to process empty script files and systemd services, causing "unbound variable" errors and build failures.

**Root Cause**: Project structure included placeholder files (empty scripts, services) that build tools attempted to validate or execute

**Solution Implemented**:
- Added minimal stub content to prevent execution errors
- Disabled systemd and script modules in recipe until implementation complete
- Renamed setup script to prevent auto-execution

**Lessons Learned**: Infrastructure build tools are less forgiving of empty/placeholder files than application frameworks

---

---

## Phase 2 Anticipated Challenges

### Challenge 2-1: Service Discovery Complexity
**Risk Level**: Medium  
**Description**: Automatically detecting and configuring services for Homepage integration

**Mitigation Strategy**:
- Start with static configuration, add discovery incrementally
- Use standard Docker labels for service metadata
- Implement robust error handling for discovery failures
- Provide manual override capabilities

---

### Challenge 2-2: Port Conflict Management
**Risk Level**: High  
**Description**: Automatically assigning ports while avoiding conflicts across stacks

**Mitigation Strategy**:
- Implement comprehensive port scanning
- Maintain port registry across all stacks
- Provide manual port assignment options
- Clear error messages for port conflicts

---

### Challenge 2-3: Stack Dependency Resolution
**Risk Level**: Medium  
**Description**: Managing dependencies between stacks and handling deployment order

**Mitigation Strategy**:
- Design simple dependency model
- Implement topological sorting for deployment order
- Provide clear dependency visualization
- Allow dependency overrides for advanced users

## Phase 3 Anticipated Challenges

### Challenge 3-1: Service API Integration
**Risk Level**: Medium  
**Description**: Integrating with various service APIs for status and management

**Mitigation Strategy**:
- Start with services that have well-documented APIs
- Implement fallback to basic connectivity checks
- Use standard API patterns where possible
- Graceful degradation when APIs unavailable

---

### Challenge 3-2: Backup System Reliability
**Risk Level**: High  
**Description**: Ensuring backup system works reliably across all stack configurations

**Mitigation Strategy**:
- Test backup/restore extensively
- Implement incremental backup strategies
- Provide multiple backup targets
- Clear validation of backup integrity

## Phase 4 Anticipated Challenges

### Challenge 4-1: Security Hardening
**Risk Level**: High  
**Description**: Implementing comprehensive security without breaking usability

**Mitigation Strategy**:
- Apply security incrementally
- Maintain usability testing throughout
- Provide security level options
- Clear documentation of security trade-offs

---

### Challenge 4-2: Performance Optimization
**Risk Level**: Medium  
**Description**: Optimizing system performance across diverse hardware configurations

**Mitigation Strategy**:
- Implement resource monitoring
- Provide hardware-specific optimizations
- Allow user configuration of resource limits
- Document performance tuning options

## Lessons Learned Template

*This template will be used to document learnings as they occur*

### Lesson [L-001]: [Lesson Title]
**Phase**: [Which phase this lesson was learned]  
**Category**: [Technical/Process/User Experience/etc.]  
**Date**: [When lesson was learned]

**Situation**: [What was happening when this lesson was learned]

**Challenge**: [What went wrong or was more difficult than expected]

**Solution**: [How the challenge was addressed]

**Key Insight**: [The main learning from this experience]

**Future Impact**: [How this changes our approach going forward]

**Related ADRs**: [Any architectural decisions that need updating]

---

## Decision Change Log

*This section tracks when architectural decisions are revisited and changed*

### Decision Change [DC-001]: [Change Title]
**Date**: [When decision was changed]  
**Original ADR**: [Reference to original decision]  
**Reason for Change**: [Why the original decision needed to be revisited]  
**New Decision**: [What the new decision is]  
**Impact**: [How this change affects the project]

---

This document serves as the project's memory, capturing not just what decisions were made, but why they were made and what we learned from implementing them. It should be updated regularly throughout development to maintain an accurate record of the project's evolution.