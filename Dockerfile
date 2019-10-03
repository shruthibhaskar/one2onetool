FROM node:10-alpine

WORKDIR /home/node/app

COPY . .

COPY package*.json ./

RUN npm install

EXPOSE 3000

CMD ["npm", "start" ]