FROM ghcr.io/cirruslabs/flutter:3.19.0 AS build
WORKDIR /app
COPY . .
RUN flutter pub get

# Build WITHOUT any environment-specific definitions
RUN flutter build web
RUN test -f /app/build/web/flutter_bootstrap.js || (echo "ERROR: flutter build web failed!" && exit 1)

FROM nginx:alpine
# Copy built assets
COPY --from=build /app/build/web /usr/share/nginx/html
# Copy nginx configuration
COPY default.conf.template /etc/nginx/templates/default.conf.template
# Copy runtime config template (relative to workspace root)
COPY config.js.template /usr/share/nginx/html/config.js.template
# Copy and set up the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]