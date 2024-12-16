FROM nginx:latest
WORKDIR /app
COPY index.html /usr/share/nginx/index.html
EXPOSE 80

