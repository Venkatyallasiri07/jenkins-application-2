# Start with the official Node.js Alpine image, which is a lighter version of Node.js
FROM node:21-alpine

# Install the 'shadow' package, which provides necessary user information files
# for some Node.js modules to function correctly. This is run with root
# privileges during the image build process.
RUN apk update && apk add --no-cache shadow

# Set the working directory for the application
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install project dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port your application will run on
EXPOSE 3000

# Define the command to run your application
CMD ["npm", "start"]