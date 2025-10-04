#!/usr/bin/env bash
# Smoke test for monitor profiles system
# Tests basic functionality in dry-run mode

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Enable dry-run mode for testing
export DRY_RUN=1

echo "==================================="
echo "Monitor Profiles - Smoke Test"
echo "==================================="
echo ""

# Test 1: Check if scripts exist
echo "Test 1: Checking if required scripts exist..."
required_scripts=(
    "monitors_menu_launcher.sh"
    "common_functions.sh"
)

all_exist=true
for script in "${required_scripts[@]}"; do
    if [[ -f "${SCRIPT_DIR}/${script}" ]]; then
        echo "  ✓ ${script} exists"
    else
        echo "  ✗ ${script} missing"
        all_exist=false
    fi
done

if [[ "${all_exist}" == "true" ]]; then
    echo "  Result: PASS"
else
    echo "  Result: FAIL"
    exit 1
fi
echo ""

# Test 2: Check if scripts have proper shebang
echo "Test 2: Checking script shebangs..."
for script in "${required_scripts[@]}"; do
    if head -n1 "${SCRIPT_DIR}/${script}" | grep -q "^#!.*bash"; then
        echo "  ✓ ${script} has bash shebang"
    else
        echo "  ✗ ${script} has invalid shebang"
        exit 1
    fi
done
echo "  Result: PASS"
echo ""

# Test 3: Bash syntax check
echo "Test 3: Checking bash syntax..."
for script in "${required_scripts[@]}"; do
    if bash -n "${SCRIPT_DIR}/${script}"; then
        echo "  ✓ ${script} syntax is valid"
    else
        echo "  ✗ ${script} has syntax errors"
        exit 1
    fi
done
echo "  Result: PASS"
echo ""

# Test 4: Source common functions
echo "Test 4: Testing common functions..."
if source "${SCRIPT_DIR}/common_functions.sh"; then
    echo "  ✓ common_functions.sh can be sourced"
else
    echo "  ✗ common_functions.sh cannot be sourced"
    exit 1
fi

# Test dry-run mode
if is_dry_run; then
    echo "  ✓ Dry-run mode is enabled"
else
    echo "  ✗ Dry-run mode is not working"
    exit 1
fi
echo "  Result: PASS"
echo ""

# Test 5: Test launcher in dry-run mode
echo "Test 5: Testing launcher script..."
if bash "${SCRIPT_DIR}/monitors_menu_launcher.sh" >/dev/null 2>&1; then
    echo "  ✓ Launcher script runs without errors"
    echo "  Result: PASS"
else
    echo "  ✗ Launcher script failed"
    echo "  Result: FAIL"
    exit 1
fi
echo ""

echo "==================================="
echo "All smoke tests passed! ✓"
echo "==================================="
