# # Use the official nginx image as base
# FROM nginx:alpine

# # Set working directory
# WORKDIR /usr/share/nginx/html

# # Copy all project files to the nginx html directory
# COPY . .

# # Create a custom nginx configuration for better performance
# RUN echo 'server { \
#     listen 80; \
#     server_name localhost; \
#     root /usr/share/nginx/html; \
#     index index.html; \
#     \
#     # Enable gzip compression \
#     gzip on; \
#     gzip_vary on; \
#     gzip_min_length 1024; \
#     gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json; \
#     \
#     # Cache static assets \
#     location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ { \
#         expires 1y; \
#         add_header Cache-Control "public, immutable"; \
#     } \
#     \
#     # Handle HTML files \
#     location / { \
#         try_files $uri $uri/ /index.html; \
#     } \
#     \
#     # Security headers \
#     add_header X-Frame-Options "SAMEORIGIN" always; \
#     add_header X-Content-Type-Options "nosniff" always; \
#     add_header X-XSS-Protection "1; mode=block" always; \
# }' > /etc/nginx/conf.d/default.conf

# # Expose port 80
# EXPOSE 80

# # Start nginx
# CMD ["nginx", "-g", "daemon off;"]


# Dockerfile
FROM nginx:alpine

# Remove default html and copy project
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*

# Copy site files into nginx html folder
COPY . .

# Ensure proper permissions
RUN chmod -R 755 /usr/share/nginx/html

# Expose container port
EXPOSE 80

# Start nginx (daemon off)
CMD ["nginx", "-g", "daemon off;"]
