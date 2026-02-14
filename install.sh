#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ASCII Art Banner
print_banner() {
    echo ""
    echo -e "${CYAN}"
    echo "   _____ _                 _ ___  "
    echo "  / ____| |               | |__ \\ "
    echo " | |    | | ___  _   _  __| |  ) |"
    echo " | |    | |/ _ \\| | | |/ _\` | / / "
    echo " | |____| | (_) | |_| | (_| ||_|  "
    echo "  \\_____|_|\\___/ \\__,_|\\__,_|(_)  "
    echo ""
    echo "      A N T I - G R A V I T Y"
    echo -e "${NC}"
    echo ""
    echo "  Agents & Skills Installer"
    echo ""
}

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*)    OS="macOS";;
        Linux*)     OS="Linux";;
        MINGW*|MSYS*|CYGWIN*)    OS="Windows";;
        *)          OS="Unknown";;
    esac
    echo -e "${BLUE}Detected OS:${NC} $OS"
}

# Check dependencies
check_deps() {
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: git is required but not installed.${NC}"
        exit 1
    fi
}

# Select runtime
select_runtime() {
    echo ""
    echo -e "${YELLOW}Step 1: Choose Runtime${NC}"
    echo ""
    echo "Which runtime(s) do you want to install for?"
    echo ""
    echo "  1) Claude Code (Recommended)"
    echo "  2) OpenCode"
    echo "  3) Gemini CLI"
    echo "  4) All of the above"
    echo ""
    read -p "Enter choice [1-4]: " runtime_choice < /dev/tty

    case $runtime_choice in
        1) RUNTIMES=("claude");;
        2) RUNTIMES=("opencode");;
        3) RUNTIMES=("gemini");;
        4) RUNTIMES=("claude" "opencode" "gemini");;
        *)
            echo -e "${RED}Invalid choice. Defaulting to Claude Code.${NC}"
            RUNTIMES=("claude")
            ;;
    esac
}

# Select location
select_location() {
    echo ""
    echo -e "${YELLOW}Step 2: Choose Location${NC}"
    echo ""
    echo "Where should skills be installed?"
    echo ""
    echo "  1) Global (all projects) - installs to ~/.<runtime>/skills/"
    echo "  2) Local (current project only) - installs to ./.<runtime>/skills/"
    echo ""
    read -p "Enter choice [1-2]: " location_choice < /dev/tty

    case $location_choice in
        1) INSTALL_GLOBAL=true;;
        2) INSTALL_GLOBAL=false;;
        *)
            echo -e "${RED}Invalid choice. Defaulting to Global.${NC}"
            INSTALL_GLOBAL=true
            ;;
    esac
}

# Get install path for a runtime
get_install_path() {
    local runtime=$1
    local base_dir

    case $runtime in
        claude)  base_dir=".claude";;
        opencode) base_dir=".opencode";;
        gemini)  base_dir=".gemini";;
    esac

    if [ "$INSTALL_GLOBAL" = true ]; then
        echo "$HOME/$base_dir/skills"
    else
        echo "./$base_dir/skills"
    fi
}

# Install skills
install_skills() {
    local REPO_URL="https://github.com/cloud9-build/agents-skills.git"
    local TMP_DIR=$(mktemp -d)

    echo ""
    echo -e "${BLUE}Downloading skills...${NC}"

    git clone --quiet --depth 1 "$REPO_URL" "$TMP_DIR" 2>/dev/null || {
        echo -e "${RED}Failed to clone repository.${NC}"
        rm -rf "$TMP_DIR"
        exit 1
    }

    for runtime in "${RUNTIMES[@]}"; do
        local install_path=$(get_install_path "$runtime")

        echo -e "${BLUE}Installing to:${NC} $install_path"

        mkdir -p "$install_path"
        cp -r "$TMP_DIR/skills/"* "$install_path/" 2>/dev/null || true

        echo -e "${GREEN}  Done${NC}"
    done

    rm -rf "$TMP_DIR"
}

# Verify installation
verify_install() {
    echo ""
    echo -e "${BLUE}Verifying installation...${NC}"

    local all_good=true

    for runtime in "${RUNTIMES[@]}"; do
        local install_path=$(get_install_path "$runtime")

        if [ -f "$install_path/god-mode/SKILL.md" ] && [ -f "$install_path/workflow/SKILL.md" ]; then
            echo -e "  ${GREEN}$runtime: Installed${NC}"
        else
            echo -e "  ${RED}$runtime: Failed${NC}"
            all_good=false
        fi
    done

    if [ "$all_good" = true ]; then
        return 0
    else
        return 1
    fi
}

# Print success message
print_success() {
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}           Installation Complete!               ${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo "Installed skills:"
    echo "  - workflow (5-Stage Pipeline: braindump, spike, build, verify, retro)"
    echo "  - board-review (Expert review panels with 5 built-in reviewers)"
    echo "  - god-mode (Parallel terminal coordination)"
    echo "  - blueprint (Visual idea planning)"
    echo "  - handoff (Context preservation)"
    echo ""
    echo -e "${CYAN}Quick start:${NC}"
    echo -e "  ${CYAN}/braindump <idea>${NC}  - Start the full planning pipeline"
    echo -e "  ${CYAN}/build <task>${NC}      - Analyze and execute any work"
    echo -e "  ${CYAN}/workflow${NC}          - See pipeline overview"
    echo -e "  ${CYAN}/gm${NC}               - Initialize parallel terminal coordination"
    echo ""
}

# Main
main() {
    print_banner
    detect_os
    check_deps
    select_runtime
    select_location
    install_skills

    if verify_install; then
        print_success
    else
        echo ""
        echo -e "${RED}Some installations failed. Please check the errors above.${NC}"
        exit 1
    fi
}

main
