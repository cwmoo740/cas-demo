FROM node:8

RUN mkdir -p /home/node/app
WORKDIR /home/node/app
COPY package.json yarn.lock index.js ./
COPY node_modules ./node_modules
#RUN yarn
ENTRYPOINT ["yarn"]
CMD ["start"]
