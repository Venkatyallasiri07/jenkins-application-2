FROM node:21-bullseye

# Create a non-root user matching Jenkins UID/GID (980:979)
RUN groupadd -g 979 jenkins && \
    useradd -m -u 980 -g jenkins jenkins

# Set HOME for netlify CLI
ENV HOME=/home/jenkins

# Install Netlify CLI globally
RUN npm install -g netlify-cli

# Switch to the jenkins user
USER jenkins

WORKDIR /home/jenkins/app

# Optional: install other tools
# RUN npm install -g your-tool

CMD ["node"]
