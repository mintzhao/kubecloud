#! /usr/bin/bash

docker rm -f mintNGINX
docker run --name mintNGINX -p 35580:35580 -p 35581:35581 -v /root/mintNGINX/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx