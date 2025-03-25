#!/bin/bash

docker run --name my-nginx \
-d \
-p 26126:80 \
-v $(pwd)/nginx_config/nginx.conf:/etc/nginx/nginx.conf \
 my-nginx:latest