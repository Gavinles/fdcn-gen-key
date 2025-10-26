FROM node:18-slim

ENV NODE_ENV=production

# create non-root user
RUN useradd --create-home --shell /bin/bash nodeapp

WORKDIR /app
COPY package*.json ./
# install production dependencies; use --omit=dev to avoid requiring package-lock.json
RUN npm install --omit=dev

COPY --chown=nodeapp:nodeapp . .
RUN npm run build

USER nodeapp
EXPOSE 3000
CMD ["npm", "start"]