
```
docker run -it -d --restart always --name redis -p 5389:6379 redis:6.0.1 --bind 0.0.0.0 --daemonize NO --protected-mode yes
```

```
consul-template -consul-addr=localhost:8500 -template=/etc/nginx/conf.d/app_real_proxy.ctmpl:/etc/nginx/conf.d/app_real_proxy.conf:"/sbin/nginx -s reload" &
```
