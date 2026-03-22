#!/bin/sh

# Default BACKEND_URL to /api if not set
export BACKEND_URL=${BACKEND_URL:-/api}

echo "Injecting runtime configuration: BACKEND_URL=$BACKEND_URL"

# Generate the real config.js from the template
envsubst < /usr/share/nginx/html/config.js.template > /usr/share/nginx/html/config.js

# Start nginx
# We use exec to ensure signals (like SIGTERM) are passed to nginx
exec nginx -g "daemon off;"
