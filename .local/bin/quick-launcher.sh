#!/usr/bin/env bash

actions="\
AI: Start AWA
Blog: New Blog Writeup
Blog: Update Blog list
DB: Initialize Postgres Database
DB: Initialize SQL Database
DB: SQL shell
DB: New SQL Backup
DB: Postgres shell
DB: New postgres Backup
AWS: New BucketStorage
AWS: Status
VM: New Virtual Machine
VM: Start Virtual Machine
System: Deep Cleanup
System: Grub Update
"

choice=$(printf "%s\n" "$actions" | fzf --height 90% --reverse --ansi \
    --prompt="System Command: "  \
    --color=fg:#e0def4,hl:#569cd6,fg+:#bbaffa,bg+:#26233a,hl+:#ebbcba,info:#31748f,pointer:#31748f,marker:#f6c177,spinner:#89b4fa,header:#cba6f7)

declare -A dispatch=(
  ["AI: Start AWA"]="$HOME/.local/bin/helpers/awa-start.sh"
  ["Blog: New Blog Writeup"]="$HOME/scripts/blog/new-blog-writeup.sh"
  ["Blog: Update Blog list"]="$HOME/scripts/blog/update-blog-list.sh"
  ["DB: Initialize Postgres Database"]="$HOME/scripts/database/init-postgres-db.sh"
  ["DB: Initialize SQL Database"]="$HOME/scripts/database/init-sql-db.sh"
  ["DB: SQL shell"]="$HOME/scripts/database/sql-shell.sh"
  ["DB: New SQL Backup"]="$HOME/scripts/database/new-sql-backup.sh"
  ["DB: Postgres shell"]="$HOME/scripts/database/postgres-shell.sh"
  ["DB: New postgres Backup"]="$HOME/scripts/database/new-postgres-backup.sh"
  ["AWS: New BucketStorage"]="$HOME/scripts/aws/new-bucket-storage.sh"
  ["AWS: Status"]="$HOME/scripts/aws/aws-status.sh"
  ["VM: New Virtual Machine"]="$HOME/.local/bin/helpers/new-vm.sh"
  ["VM: Start Virtual Machine"]="$HOME/.local/bin/helpers/start-vm.sh"
  ["System: Deep Cleanup"]="$HOME/scripts/system/deep-cleanup.sh"
  ["System: Grub Update"]="$HOME/scripts/system/grub-update.sh"
)

if [[ -n "$choice" && -n "${dispatch[$choice]}" ]]; then
    bash "${dispatch[$choice]}"
else
    echo "No valid action selected."
fi
