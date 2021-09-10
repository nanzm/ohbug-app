FROM node:14.16.1-alpine3.13 as builder
#ENV TZ Asia/Shanghai
WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile
COPY . .
RUN yarn build

# nginx
FROM nginx:1.21.1 AS final
ENV TZ Asia/Shanghai
COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
