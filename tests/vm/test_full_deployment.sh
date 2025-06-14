#!/bin/bash
# BlueLab VM Deployment Test Script
# Automates VM testing with various parameter combinations

set -euo pipefail

# Configuration
TEST_NAME="BlueLab VM Deployment Test"
LOG_DIR="./test-logs"
RESULTS_FILE="$LOG_DIR/test-results-$(date +%Y%m%d-%H%M%S).log"

# Test scenarios
declare -A TEST_SCENARIOS=(
    ["minimal"]="bluelab.username=testuser bluelab.password=testpass123"
    ["full"]="bluelab.username=admin bluelab.password=secure123 bluelab.hostname=bluelab-test bluelab.timezone=America/New_York bluelab.stacks=monitoring,media"
    ["interactive"]=""
    ["edge-case"]="bluelab.username=test@user bluelab.password='p@ss w0rd!' bluelab.timezone=Invalid/Zone"
)

# Setup
setup_test_environment() {
    echo "Setting up test environment..."
    mkdir -p "$LOG_DIR"
    
    # Check for required tools
    local required_tools=("curl" "jq")
    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "ERROR: Required tool '$tool' not found"
            exit 1
        fi
    done
    
    echo "Test environment ready"
}

# Log function
log_test() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" | tee -a "$RESULTS_FILE"
}

# Check if BlueLab ISO is available
check_iso_availability() {
    log_test "Checking for latest BlueLab ISO..."
    
    # This would check CI/CD artifacts or build output
    # For now, just verify the recipe builds
    if [ -f "../../recipes/recipe.yml" ]; then
        log_test " BlueLab recipe found"
        return 0
    else
        log_test "L BlueLab recipe not found"
        return 1
    fi
}

# Generate iVentoy boot configuration
generate_iventoy_config() {
    local scenario="$1"
    local parameters="${TEST_SCENARIOS[$scenario]}"
    
    log_test "Generating iVentoy config for scenario: $scenario"
    
    cat > "$LOG_DIR/iventoy-$scenario.json" << EOF
{
    "control": [
        {
            "VTOY_DEFAULT_SEARCH_ROOT": "/ventoy/iso",
            "VTOY_FILE_FLT_EFI": 0
        }
    ],
    "injection": [
        {
            "image": "/ventoy/iso/bluelab-*.iso",
            "archive": "/ventoy/injection/bluelab-injection.tar.gz"
        }
    ],
    "auto_install": [
        {
            "image": "/ventoy/iso/bluelab-*.iso",
            "template": "/ventoy/autoinstall/bluelab-$scenario.cfg"
        }
    ],
    "boot_append": [
        {
            "image": "/ventoy/iso/bluelab-*.iso",
            "append": "$parameters"
        }
    ]
}
EOF
    
    log_test "iVentoy config generated: $LOG_DIR/iventoy-$scenario.json"
}

# Test VM deployment (manual step guidance)
test_vm_deployment() {
    local scenario="$1"
    
    log_test "=== Testing VM Deployment Scenario: $scenario ==="
    
    generate_iventoy_config "$scenario"
    
    cat << EOF | tee -a "$RESULTS_FILE"

MANUAL TEST STEPS FOR SCENARIO: $scenario
========================================

1. VM Setup:
   - Create new VM (4GB RAM, 60GB disk, 2 CPU)
   - Configure network (NAT or bridged)
   - Boot from iVentoy with generated config

2. Parameters for this test:
   ${TEST_SCENARIOS[$scenario]}

3. Monitor during boot:
   - Watch for first-boot service startup
   - Monitor logs: journalctl -fu bluelab-first-boot
   - Note any error messages

4. Validation checklist:
   [ ] First-boot service runs without errors
   [ ] User account created successfully
   [ ] Network configuration completed
   [ ] Docker services deployed
   [ ] Web interfaces accessible
   [ ] Completion marker created: /var/lib/bluelab/.first-boot-complete

5. Test accessibility:
   [ ] http://bluelab.local:3000 (Homepage)
   [ ] http://bluelab.local:5001 (Dockge)
   [ ] Services respond correctly
   [ ] No error messages in logs

6. Post-reboot test:
   [ ] Reboot VM
   [ ] Services start automatically
   [ ] First-boot does not re-run
   [ ] Web interfaces still accessible

RECORD RESULTS IN: $RESULTS_FILE

EOF
}

# Simulate service health check (for future automation)
simulate_health_check() {
    local scenario="$1"
    
    log_test "Simulating health check for scenario: $scenario"
    
    # This would eventually connect to VM and run actual checks
    # For now, provide checklist for manual verification
    
    cat << EOF | tee -a "$RESULTS_FILE"

HEALTH CHECK SIMULATION - $scenario
====================================

Services to verify:
- Homepage (port 3000): [ ] UP [ ] DOWN
- Dockge (port 5001): [ ] UP [ ] DOWN
- Docker daemon: [ ] RUNNING [ ] STOPPED

System status:
- Disk usage: [ ] <80% [ ] >80%
- Memory usage: [ ] <80% [ ] >80%
- CPU load: [ ] <2.0 [ ] >2.0

Network connectivity:
- Internet access: [ ] YES [ ] NO
- DNS resolution: [ ] YES [ ] NO
- Local hostname: [ ] RESOLVES [ ] FAILS

EOF
}

# Generate test report
generate_test_report() {
    log_test "Generating comprehensive test report..."
    
    cat << EOF | tee -a "$RESULTS_FILE"

BLUELAB VM TESTING SUMMARY
==========================
Date: $(date)
Test scenarios: ${!TEST_SCENARIOS[@]}

NEXT STEPS:
1. Execute manual tests for each scenario
2. Document pass/fail results in this file
3. Report any issues found
4. Update automation based on findings

TEST ARTIFACTS:
- Results file: $RESULTS_FILE
- iVentoy configs: $LOG_DIR/iventoy-*.json
- Test logs: $LOG_DIR/

EOF
    
    echo "Test report generated: $RESULTS_FILE"
}

# Main execution
main() {
    echo "Starting $TEST_NAME"
    echo "========================================"
    
    setup_test_environment
    
    if ! check_iso_availability; then
        echo "Cannot proceed without BlueLab ISO"
        exit 1
    fi
    
    # Generate test configs for each scenario
    for scenario in "${!TEST_SCENARIOS[@]}"; do
        test_vm_deployment "$scenario"
        simulate_health_check "$scenario"
        echo "" | tee -a "$RESULTS_FILE"
    done
    
    generate_test_report
    
    echo "========================================"
    echo "VM deployment test preparation complete"
    echo "Manual testing steps generated in: $RESULTS_FILE"
    echo "Execute tests and document results in the same file"
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi