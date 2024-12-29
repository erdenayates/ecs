# Build stage
FROM node:18-alpine as build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Set default API URL for build time
ARG REACT_APP_API_URL=http://localhost:3000
ENV REACT_APP_API_URL=$REACT_APP_API_URL

RUN npm run build

# Production stage
FROM nginx:alpine

# Copy the build output and nginx configuration
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/templates/default.conf.template

# Create a script to inject runtime environment variables
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'echo "window.REACT_APP_API_URL = \"$REACT_APP_API_URL\";" > /usr/share/nginx/html/config.js' >> /docker-entrypoint.sh && \
    echo 'envsubst "\$BACKEND_URL" < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf' >> /docker-entrypoint.sh && \
    echo 'exec nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Set default environment variables
ENV BACKEND_URL=http://localhost:3000
ENV REACT_APP_API_URL=http://localhost

EXPOSE 80
CMD ["/docker-entrypoint.sh"] 