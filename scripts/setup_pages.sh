#!/usr/bin/env bash
#
# setup_pages.sh — One-shot init and push of this folder to a GitHub repo
# that will host the project page on GitHub Pages.
#
# Prerequisite: create an EMPTY repo on GitHub.com (no README, no .gitignore).
# Default name: unified-fluid-robot-multiphysics
#
# Usage: bash scripts/setup_pages.sh

set -euo pipefail

# ---- color output ----
if [ -t 1 ]; then
  C_RESET=$'\033[0m'
  C_BOLD=$'\033[1m'
  C_BLUE=$'\033[34m'
  C_GREEN=$'\033[32m'
  C_DIM=$'\033[2m'
else
  C_RESET=''; C_BOLD=''; C_BLUE=''; C_GREEN=''; C_DIM=''
fi

info() { echo "${C_BLUE}${C_BOLD}==>${C_RESET} $*"; }
done_msg() { echo "${C_GREEN}${C_BOLD}✓${C_RESET} $*"; }

# ---- sanity check ----
if [ ! -f "index.html" ]; then
  echo "Run this script from the project root (where index.html lives)."
  exit 1
fi

if [ -d ".git" ]; then
  info "This folder is already a git repo. If you want to start over,"
  info "remove .git and run again:  rm -rf .git"
  exit 1
fi

# ---- gather config ----
echo
info "Make sure you've created an empty repo on GitHub:"
echo "    ${C_DIM}https://github.com/new${C_RESET}"
echo "    (No README, no .gitignore, no license — we have our own.)"
echo

read -p "GitHub username: " USERNAME
read -p "Repo name [unified-fluid-robot-multiphysics]: " REPO
REPO=${REPO:-unified-fluid-robot-multiphysics}

echo
echo "Authentication:"
echo "  1) HTTPS (you'll be prompted for username + Personal Access Token)"
echo "  2) SSH   (uses your GitHub SSH key)"
read -p "Choose [1/2]: " AUTH
AUTH=${AUTH:-1}

if [ "$AUTH" = "2" ]; then
  REMOTE="git@github.com:${USERNAME}/${REPO}.git"
else
  REMOTE="https://github.com/${USERNAME}/${REPO}.git"
fi

# ---- run ----
info "git init"
git init -b main >/dev/null

info "git add ."
git add .

info "git commit"
git commit -m "Initial project page" >/dev/null

info "git remote add origin ${REMOTE}"
git remote add origin "$REMOTE"

info "git push -u origin main"
git push -u origin main

echo
done_msg "Pushed."
echo
echo "Now finish in the browser:"
echo "  1. Open ${C_BOLD}https://github.com/${USERNAME}/${REPO}/settings/pages${C_RESET}"
echo "  2. Under 'Source', select 'Deploy from a branch'."
echo "  3. Pick branch ${C_BOLD}main${C_RESET}, folder ${C_BOLD}/ (root)${C_RESET}, click Save."
echo "  4. Wait ~1 min, then visit:"
echo "     ${C_GREEN}${C_BOLD}https://${USERNAME}.github.io/${REPO}/${C_RESET}"
echo
