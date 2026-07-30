#!/bin/bash

# Hook that runs when submitting a PR with /submit-pr command
# Checks for dependency updates and generates a report

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if package.json exists in the repository
if [ -f "package.json" ]; then
    # Check if package.json has been modified
    if git diff origin/$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's/origin\///')...HEAD --name-only | grep -q "package.json"; then
        echo -e "${YELLOW}📦 Detected dependency changes. Generating report...${NC}"

        # Generate the dependency report
        REPORT=$(node ~/.claude/scripts/analyze-dependency-changes.js 2>/dev/null || echo "")

        if [ -n "$REPORT" ]; then
            echo -e "${GREEN}Dependency Report:${NC}"
            echo "$REPORT"
            echo ""
            echo -e "${YELLOW}This report will be included in your PR description.${NC}"
        fi
    fi
fi

exit 0