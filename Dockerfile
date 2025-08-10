# Use the Node.js 20 base image on Debian Bookworm
FROM node:20-bookworm-slim

# Install Playwright and other system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libnss3 \
    libx11-6 \
    libxrandr2 \
    libxkbcommon0 \
    libxcursor1 \
    libxcomposite1 \
    libxdamage1 \
    libxtst6 \
    libgtk-3-0 \
    libgbm1 \
    libasound2 \
    libdbus-glib-1-2 \
    libgdk-pixbuf2.0-0 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libegl1 \
    libwebp7 \
    libgles2 \
    libjpeg62-turbo \
    libfontconfig1 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libharfbuzz0b \
    libxrender1 \
    libxinerama1 \
    libxss1 \
    libxfixes3 \
    libpangocairo-1.0-0 \
    libpango-1.0-0 \
    libharfbuzz-icu0 \
    libsecret-1-0 \
    locales \
    woff-tools \
    libtiff6 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Download Playwright browsers
RUN npx playwright install

# Copy the rest of the application code
COPY . .


# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]



#This Dockerfile uses node:21-alpine as a base image and then installs the shadow package to resolve the ENOENT error.
# This allows you to avoid using the root user in your Jenkins pipeline.

# docker build -t netlify-jenkins:latest .
# The -t flag tags the image with a name and version. The . specifies the location of the Dockerfile

# Build and push the custom image to a Docker registry
# docker tag netlify-jenkins vy4273/netlify-jenkins:latest

#Push the image to the registry:
# docker push vy4273/netlify-jenkins:latest

