apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "frontend-loader.fullname" . }}-nginx-conf
  labels:
    {{- include "frontend-loader.labels" . | nindent 4 }}
data:
  default.conf: |
      server {
        listen       8080;
        listen  [::]:8080;
        server_name  localhost;

        gzip  on;
        gzip_vary on;
        gzip_min_length 10240;
        gzip_proxied expired no-cache no-store private auth;
        gzip_types text/plain text/css text/xml text/javascript application/javascript application/x-javascript application/xml image/svg+xml application/octet-stream application/json;
  
        #charset koi8-r;
        access_log /dev/stdout;

        location / {
            absolute_redirect on;
            if ($request_uri ~ ^([^.\?]*[^/])$) {
              return 301 https://$http_host$uri/;
            }
            root   /usr/share/nginx/html;
            try_files $uri $uri/index.html =404;
        }

        error_page 400 /ErrorPages/HTTP400.html;
        error_page 401 /ErrorPages/HTTP401.html;
        error_page 402 /ErrorPages/HTTP402.html;
        error_page 403 /ErrorPages/HTTP403.html;
        error_page 404 /ErrorPages/HTTP404.html;
        error_page 500 /ErrorPages/HTTP500.html;
        error_page 501 /ErrorPages/HTTP501.html;
        error_page 502 /ErrorPages/HTTP502.html;
        error_page 503 /ErrorPages/HTTP503.html;

        location /ErrorPages/ {
            alias /usr/share/nginx/html/nginx-error/;
            internal;
        }
      }
