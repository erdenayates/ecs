FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./
RUN npm install --production

# Copy source code
COPY src/ ./src/

# Make sure the files exist
RUN ls -la /app/src/

EXPOSE 3000

# Use node directly instead of npm
CMD ["node", "src/index.js"] 