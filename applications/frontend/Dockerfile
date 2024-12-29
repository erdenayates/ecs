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

# Create a script to replace the API URL at runtime
RUN echo "window.REACT_APP_API_URL = '${REACT_APP_API_URL}';" > /usr/share/nginx/html/config.js

# Add config.js to index.html
RUN sed -i '/<head>/a \    <script src="/config.js"></script>' /usr/share/nginx/html/index.html

ENV BACKEND_URL=http://localhost:3000

EXPOSE 80
CMD ["sh", "-c", "envsubst '${BACKEND_URL}' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"] 