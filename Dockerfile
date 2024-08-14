FROM nginx:alpine

COPY rpms /usr/share/nginx/html/rpms
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
