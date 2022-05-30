### redis
```bash
docker run -it -d --restart always --name redis -p 5389:6379 redis:6.0.1 --bind 0.0.0.0 --daemonize NO --protected-mode YES
```

如果配置了密码:

```yml
  jedis:
    host: 192.168.100.100
    port: 5389
    password: '{F%!X}sb6fDN{7Jb}9P_'
    database: 3

 lettuce:
   uri: redis://%7BF%25!X%7Dsb6fDN%7B7Jb%7D9P_@192.168.100.100:5389/
```





### mqtt emqx

```bash
docker run -d --name emqx -p 6881:1883 -p 6882:8083 -p 6883:8883 -p 6884:8084 -p 6885:18083 -p 6886:8081 emqx/emqx
```
- 使用浏览器打开地址 http://127.0.0.1:6885 ，如需登录输入默认用户名 admin 与默认密码 public
