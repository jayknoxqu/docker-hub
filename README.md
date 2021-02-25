
```
docker run -it -d --restart always --name redis -p 5389:6379 redis:6.0.1 --bind 0.0.0.0 --daemonize NO --protected-mode yes
```
