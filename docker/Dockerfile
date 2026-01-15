FROM nginx:stable-alpine3.23

WORKDIR /var/www/septa

COPY ./index.html /usr/share/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]