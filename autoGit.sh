#!/bin/bash
# CARLOS ENAMORADO #


#########
#  _____
# /     \
#| () () |
# \  ^  /
#  |||||
#  |||||
#
#########


# Set variables
REPO_DIR="~/Documents/Obsidian Vault"
COMMIT_MESSAGE="Automated commit $(date +'%Y-%m-%d %H:%M:%S')"
BRANCH="main"  # Update with your branch name if different

# Navigate to the repository directory
cd "$REPO_DIR"

# Check for changes
if [[ -n $(git status -s) ]]; then
  # Stage all changes
  git add .

  # Commit changes
  git commit -m "$COMMIT_MESSAGE"

  # Push changes
  git push origin "$BRANCH"
else
  echo "No changes to commit"
fi
