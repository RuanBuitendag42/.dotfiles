#!/usr/bin/env bash
# Script: validate-deploy.sh
# Purpose: Verify Copilot agent files are correctly deployed
# Usage: ./validate-deploy.sh [target-directory]
#   No args: checks global (~/.config/Code/User/prompts/)
#   With arg: checks the specified directory

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Target directory
TARGET="${1:-$HOME/.config/Code/User/prompts}"

echo "Validating Copilot deployment in: $TARGET"
echo "=========================================="

ERRORS=0
WARNINGS=0
OK=0

# Check directory exists
if [[ ! -d "$TARGET" ]]; then
    echo -e "${RED}ERROR: Directory does not exist: $TARGET${NC}"
    exit 1
fi

# Validate agent files
echo ""
echo "Checking agent files (*.agent.md)..."
for f in "$TARGET"/*.agent.md; do
    [[ -f "$f" ]] || continue
    basename=$(basename "$f")

    # Check lowercase-with-hyphens naming
    if [[ ! "$basename" =~ ^[a-z][a-z0-9-]*\.agent\.md$ ]]; then
        echo -e "  ${RED}ERROR: Invalid filename: $basename${NC}"
        ((ERRORS++))
    else
        # Check frontmatter exists
        if head -1 "$f" | grep -q '^---$'; then
            # Check description field
            if grep -q '^description:' "$f"; then
                echo -e "  ${GREEN}OK: $basename${NC}"
                ((OK++))
            else
                echo -e "  ${RED}ERROR: Missing 'description' in frontmatter: $basename${NC}"
                ((ERRORS++))
            fi
        else
            echo -e "  ${RED}ERROR: Missing frontmatter (---) in: $basename${NC}"
            ((ERRORS++))
        fi
    fi
done

# Validate instruction files
echo ""
echo "Checking instruction files (*.instructions.md)..."
for f in "$TARGET"/*.instructions.md; do
    [[ -f "$f" ]] || continue
    basename=$(basename "$f")

    if head -1 "$f" | grep -q '^---$'; then
        if grep -q '^description:' "$f" && grep -q '^applyTo:' "$f"; then
            echo -e "  ${GREEN}OK: $basename${NC}"
            ((OK++))
        else
            echo -e "  ${RED}ERROR: Missing required frontmatter (description/applyTo): $basename${NC}"
            ((ERRORS++))
        fi
    else
        echo -e "  ${RED}ERROR: Missing frontmatter: $basename${NC}"
        ((ERRORS++))
    fi
done

# Validate skill directories
echo ""
echo "Checking skills directories..."
if [[ -d "$TARGET/genesis-skills" ]]; then
    for d in "$TARGET/genesis-skills"/*/; do
        [[ -d "$d" ]] || continue
        dirname=$(basename "$d")

        if [[ -f "$d/SKILL.md" ]]; then
            # Check name matches folder
            skill_name=$(grep '^name:' "$d/SKILL.md" | head -1 | sed 's/name: *//' | tr -d "'" | tr -d '"')
            if [[ "$skill_name" == "$dirname" ]]; then
                echo -e "  ${GREEN}OK: $dirname/SKILL.md${NC}"
                ((OK++))
            else
                echo -e "  ${YELLOW}WARNING: Skill name '$skill_name' doesn't match folder '$dirname'${NC}"
                ((WARNINGS++))
            fi
        else
            echo -e "  ${RED}ERROR: Missing SKILL.md in: $dirname/${NC}"
            ((ERRORS++))
        fi
    done
else
    echo -e "  ${YELLOW}WARNING: No genesis-skills/ directory found${NC}"
    ((WARNINGS++))
fi

# Summary
echo ""
echo "=========================================="
echo "Validation Summary:"
echo -e "  ${GREEN}Passed: $OK${NC}"
echo -e "  ${YELLOW}Warnings: $WARNINGS${NC}"
echo -e "  ${RED}Errors: $ERRORS${NC}"

if [[ $ERRORS -gt 0 ]]; then
    echo -e "\n${RED}Deployment has errors — fix before using.${NC}"
    exit 1
else
    echo -e "\n${GREEN}Deployment looks good, boet!${NC}"
    exit 0
fi
