# Set Up Password Authentication with Nginx for ruTorrent

### Create the Password File

##### Create the Password File Using the OpenSSL Utilities

Add username to the file using this command:

```
$ sudo echo -n '${USER}:' >> ~/rutorrent/config/nginx/.htpasswd
```

Next, add an encrypted password for the username:

```
$ sudo openssl passwd -apr1 >> ~/rutorrent/config/nginx/.htpasswd
```

##### Create the Password File Using htpasswd

```
$ sudo htpasswd -c ~/rutorrent/config/nginx/.htpasswd ${USER}
```

### Configure Nginx Password Authentication

Open config file:

```
$ sudo nano rutorrent/config/nginx/site-confs/default
```

Add "auth_basic" and "auth_basic_user_file":

```
upstream backendrtorrent {
    server unix:/run/php/.rtorrent.sock;
}

server {
    listen 80 default_server;

    listen 443 ssl;

    root /app/rutorrent;
    index index.php index.html index.htm;

    server_name _;

    ssl_certificate /config/keys/cert.crt;
    ssl_certificate_key /config/keys/cert.key;

    client_max_body_size 0;

    location / {
        location ~ .php$ {
            fastcgi_split_path_info ^(.+\.php)(.*)$;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include /etc/nginx/fastcgi_params;
        }

        # ADD THIS CONFIG
        auth_basic "Restricted Content";
        auth_basic_user_file /config/nginx/.htpasswd;
    }

    location /RPC2 {
        access_log /config/log/nginx/rutorrent.rpc2.access.log;
        error_log /config/log/nginx/rutorrent.rpc2.error.log;
        include /etc/nginx/scgi_params;
        scgi_pass backendrtorrent;

        # ADD THIS CONFIG
        auth_basic "Restricted Content";
        auth_basic_user_file /config/nginx/.htpasswd;
    }
}
```

Save and close the file when you are finished. Restart ruTorrent:

```
$ sudo docker restart rutorrent
```
