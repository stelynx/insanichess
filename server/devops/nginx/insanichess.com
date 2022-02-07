server {
    listen 80;
    listen [::]:80;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;

    server_name insanichess.com www.insanichess.com;

    location /api {
        if ( $request_method == OPTIONS ) {
            add_header Content-Length 0;
            add_header Content-Type text/plain;
            add_header Allow-Access-Control-Origin *;
            add_header Allow-Access-Control-Methods "GET, POST, PATCH, DELETE";
            add_header Allow-Access-Control-Headers "content-type, authorization";
            return 200;
        }
        proxy_pass http://localhost:4040;
        add_header Allow-Access-Control-Origin *;
        add_header Allow-Access-Control-Methods "GET, POST, PATCH, DELETE";
        add_header Allow-Access-Control-Headers "content-type, authorization";
    }

    location /wss {
        proxy_pass http://localhost:4040;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_buffering off;
    }
}