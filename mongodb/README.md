```yaml
version: '2'
services:
  mongodb:
    image: mongo
    restart: always
    container_name: mongodb
    environment:
         #设置admin数据库的账号和密码
        - MONGO_INITDB_ROOT_USERNAME=root
        - MONGO_INITDB_ROOT_PASSWORD=rootPass
    ports:
      - 27017:27017
    volumes:
      - /var/lib/mongodb/configdb:/data/configdb
      - /var/lib/mongodb/db:/data/db
      - /var/lib/mongodb/initdb.d:/docker-entrypoint-initdb.d
    command: mongod
```



在/mongodb/initdb.d目录下创建 initdb_user.sh初始化数据库脚本

文件命名随意，只要以sh结尾即可，可以有多个初始化脚本

```shell
#!/usr/bin/env bash
echo "Creating mongo users..."

mongo admin -u root -p root123456 << EOF
use test_db;
db.createUser({
    user: 'test',
    pwd: 'test123456',
    roles: [{
        role: 'dbOwner',
        db: 'test_db'
    }]
});
EOF

mongo admin -u root -p root123456 << EOF
use prod_db;
db.createUser({
    user: 'prod',
    pwd: 'prod123456',
    roles: [{
        role: 'readWrite',
        db: 'prod_db'
    }]
});
EOF

echo "Mongo users created..."
```

**说明:**

1. 创建一个 test_db 数据库的用户：test ，密码：test123456 ，角色：dbOwner
2. 创建一个 prod_db 数据库的用户：prod ，密码：prod123456 ，角色：readWrite



**赋予文件权限**

```
chmod 777 configdb db
```

**为脚本添加可执行权限**

```shell
chmod +x initdb.d/initdb_user.sh
```


**将脚本转化为liunx可读文件**

```shell
#安装
sudo yum install -y dos2unix

#转化
dos2unix initdb.d/initdb_user.sh
```



执行命令`docker-compose up -d`

查看日志 `docker-compose logs`



##### 参考文档

`https://hub.docker.com/_/mongo?tab=description`