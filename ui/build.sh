#!/bin/bash
set -e
cd "$(dirname "$0")"

# Source nvm so we use Node 22
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

npm run build
echo "Build complete → ../desk/www/"
