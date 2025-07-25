# Use the official Nginx image as the base image
FROM nginx:latest

# Copy custom configuration file to the container
COPY nginx_config/nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for HTTP traffic
EXPOSE 80