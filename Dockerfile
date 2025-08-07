#This file will build a new image based on node:21-alpine and 
#install the shadow package during the image build process, where root permissions are available.

# Starting with the official Node.js Alpine image, which is a lighter version of Node.js
FROM node:21-alpine

# Installing the 'shadow' package, which provides necessary user information files
# for some Node.js modules to function correctly. This is run with root
# privileges during the image build process.
RUN apk update && apk add --no-cache shadow

# Setting the working directory for the application
WORKDIR /app

# Copying package.json and package-lock.json to install dependencies
COPY package*.json ./

# Installing project dependencies
RUN npm install

# Copying the rest of the application code
COPY . .

# Exposing the port the application will run on
EXPOSE 3000

# The command to run your application
CMD ["npm", "start"]

#This Dockerfile uses node:21-alpine as a base image and then installs the shadow package to resolve the ENOENT error.
# This allows you to avoid using the root user in your Jenkins pipeline.

# docker build -t netlify-jenkins:latest .
# The -t flag tags the image with a name and version. The . specifies the location of the Dockerfile

# Build and push the custom image to a Docker registry
# docker tag netlify-jenkins vy4273/netlify-jenkins:latest

#Push the image to the registry:
# docker push vy4273/netlify-jenkins:latest

