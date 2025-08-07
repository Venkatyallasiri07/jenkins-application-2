# Start with the official Node.js Alpine image
FROM node:21-alpine

# Install the 'shadow' package to provide user information
# The 'apk' command is executed as root during the image build
RUN apk update && apk add --no-cache shadow

# Set the default non-root user for security (already the default, but good practice)
USER node