FROM mcr.microsoft.com/playwright:v1.39.0-jammy

RUN npm install -g netlify-cli@13.2.0 serve

RUN apt install jq -y