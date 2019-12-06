### 配置goaccess



#### nginx日志默认格式

```nginx
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for"';
```



#### 转换日志格式

转换 Nginx日志格式([log_format](http://nginx.org/en/docs/http/ngx_http_log_module.html))为goaccess可识别的格式([goaccess config](https://goaccess.io/man))

```bash
# 下载脚本
[root@localhost ~]# curl -O  https://raw.githubusercontent.com/stockrt/nginx2goaccess/master/nginx2goaccess.sh

# 赋予可执行权限
[root@localhost ~]# chmod +x nginx2goaccess.sh

# 格式化nginx日志格式
[root@localhost ~]# ./nginx2goaccess.sh '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent" "$http_x_forwarded_for"'

- Generated goaccess config:

time-format %T
date-format %d/%b/%Y
log_format %h - %^ [%d:%t %^] "%r" %s %b "%R" "%u" "%^"

```

将结果写入到`goaccess.conf`文件中

```
time-format %T
date-format %d/%b/%Y
log_format %h - %^ [%d:%t %^] "%r" %s %b "%R" "%u" "%^"
```



### nginx配置
```
server{

    server_name example.com;
    listen 80;

    # 访问分析结果的静态页
    location / {
        alias /var/lib/goaccess;
        autoindex on;
        index index.html;
   }

   # websocket代理, 用于实时推送数据
   location /goaccess {
        proxy_pass http://localhost:7890;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

}
```