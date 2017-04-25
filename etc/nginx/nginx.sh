#! /usr/bin/bash

docker run --name mintNGINX -p 35580:35580  -v /root/mintNGINX/nginx.conf:/etc/nginx/nginx.conf:ro -d nginx