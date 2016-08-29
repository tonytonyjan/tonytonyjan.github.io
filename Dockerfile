FROM nginx
RUN rm -rf /usr/share/nginx/html && mv . /usr/share/nginx/html
