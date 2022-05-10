### redis
```
docker run -it -d --restart always --name redis -p 5389:6379 redis:6.0.1 --bind 0.0.0.0 --daemonize NO --protected-mode YES
```

### mqtt emqx
```
docker run -d --name emqx -p 6881:1883 -p 6882:8083 -p 6883:8883 -p 6884:8084 -p 6885:18083 -p 6886:8081 emqx/emqx
```
- 使用浏览器打开地址 http://127.0.0.1:6885 ，如需登录输入默认用户名 admin 与默认密码 public
