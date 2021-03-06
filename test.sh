tee /etc/nginx/conf.d/testwordshark.gospely.com.conf <<- 'EOF'
upstream nodejs__upstream_testwordshark {
        server 127.0.0.1:20404;
        keepalive 64;
}

server {
        listen 80;
        server_name www.testwordshark.gospely.com testwordshark.gospely.com;
        #access_log /var/log/nginx/moiveme.log;
        location / {
          proxy_set_header   X-Real-IP            $remote_addr;
          proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
          proxy_set_header   Host                   $http_host;
          proxy_set_header   X-NginX-Proxy    true;
          proxy_set_header   Connection "";
          proxy_http_version 1.1;
          proxy_pass         http://nodejs__upstream_testwordshark;
        }
}
EOF
