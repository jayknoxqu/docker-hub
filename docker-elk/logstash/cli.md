```
校验配置是否正确
bin/logstash -f pipeline/logstash.conf --config.test_and_exit

自动加载配置文件,间隔60秒
bin/logstash -f pipeline/logstash.conf --config.reload.automatic --config.reload.interval 60s
```

