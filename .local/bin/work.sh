#!/bin/sh

projects_dir="$HOME/programming"  # Default directory
only_cd=false
query=""

# Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    -c)
      only_cd=true
      shift
      ;;
    -d)
      projects_dir="$2"
      shift 2
      ;;
    *)
      query="$1"
      shift
      ;;
  esac
done

cd "$projects_dir" || exit 1

# Find directories exactly 2 levels deep
project=$(find . -mindepth 1 -maxdepth 2 -type d | sed 's#^\./##' | \
  fzf --prompt="Select Project: " --query="$query")

if [ -n "$project" ]; then
  cd "$projects_dir/$project" || exit 1
  echo "Switched to $projects_dir/$project"

  if [ "$only_cd" = false ]; then
     nvim .
  else 
      cd "$projects_dir/$project"
  fi
else
  echo "No project selected."
fi
