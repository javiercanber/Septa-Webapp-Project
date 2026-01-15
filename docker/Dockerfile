FROM nginx:stable-alpine3.23

WORKDIR /var/www/septa

COPY ./index.html /var/www/septa

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]