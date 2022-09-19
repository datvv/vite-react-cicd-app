# build stage
FROM node:18 as build-stage

ENV HOME /opt/src/app
WORKDIR $HOME

COPY ["package.json", "yarn.lock", "./"]
RUN yarn install

COPY . .
RUN yarn install --force
RUN yarn build

# production stage
FROM nginxinc/nginx-unprivileged:stable-alpine as production-stage
COPY --from=build-stage /opt/src/app/dist /usr/share/nginx/html
# COPY default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]