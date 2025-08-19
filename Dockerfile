FROM node:20-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY package*.json ./
RUN npm install --only=production
COPY . .
EXPOSE 3001
HEALTHCHECK CMD wget -qO- http://localhost:3001/health || exit 1
CMD ["node", "index.js"]
