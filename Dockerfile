# Use a small webserver image
FROM nginx:alpine

# Remove default nginx content and copy our static site
RUN rm -rf /usr/share/nginx/html/*
COPY . /usr/share/nginx/html

# Expose nginx port (not strictly required, but helpful for docs)
EXPOSE 80

# nginx image already has a CMD to start nginx in foreground.
