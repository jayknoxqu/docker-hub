

### [下载](https://github.com/chrislusf/seaweedfs/releases)
```bash
wget https://github.com/chrislusf/seaweedfs/releases/download/3.06/linux_amd64.tar.gz
```


### 解压

```bash
tar -zxvf linux_amd64.tar.gz
```


### 安装

```bash
mv weed /usr/local/bin/weed
```

### [文档](https://github.com/chrislusf/seaweedfs/wiki)
```sh
#概况
weed -h
#中央服务器
weed master -h
#存储服务器
weed volume -h
```

### 单机

#### master（中央服务器）

设置一台 master，两台 volume ，同一个 dataCenter（机房），同一个 rack（机架），备份策略（001）：相同的机架里备份一份数据

```bash
nohup weed master -port=9333 -volumeSizeLimitMB=1024 -defaultReplication=001 -mdir=/mnt/weedfs/m1 > m1.log &
```

- defaultReplication（副本策略）：是 **xyz** 顺序排列的数值，默认值：000 不备份。

| **数值** | **含义**                                                     |
| :------: | ------------------------------------------------------------ |
|    x     | 在不同的 dataCenter（机房），所需要备份的数量                 |
|    y     | 在相同的 dataCenter（机房），不同的 rack（机架），所需要备份的数量 |
|    z     | 在相同的 dataCenter（机房），相同的 rack（机架），所需要备份的数量 |



#### volume（存储服务器）

```bash
nohup weed volume -port=9222 -mserver="localhost:9333" -publicUrl=/volume1 -max=500 -dir=/mnt/weedfs/v1 > v1.log &

nohup weed volume -port=9223 -mserver="localhost:9333" -publicUrl=/volume2 -max=500 -dir=/mnt/weedfs/v2 > v2.log &
```

-  -max参数为最大逻辑卷数量，如果磁盘可用空间为500G，`( 500 * 1024 ) / 1024[volumeSizeLimitMB] = 500`，那最大值为 -max = 500



#### nginx（代理服务器）

```nginx
server {
    
	listen       80;
    server_name  file.example.com;
    
	location /volume1/ {
   		proxy_pass http://localhost:9222/;
	}

	location /volume2/ {
  		  proxy_pass http://localhost:9223/;
	}
    
}
```

**代理详情，如下：**

- 用户访问的地址：http://file.example.com/volume1/6,06bb28cc0d.png

- 实际访问的地址：http://127.0.0.1:9222/6,06bb28cc0d.png





### 集群

#### master（中央服务器）

设置三台 master （必须为奇数），三台 volume，不同的 dataCenter（机房），不同的 rack（机架），备份策略（100）：不同的机房里备份一份数据

```bash
nohup weed master -port=9333 -ip=192.168.0.1 -peers=192.168.0.1:9333,192.168.1.1:9334,192.168.1.2:9335 -volumeSizeLimitMB=1024 -defaultReplication=100 -mdir=/mnt/weedfs/m1 > m1.log &

nohup weed master -port=9334 -ip=192.168.1.1 -peers=192.168.0.1:9333,192.168.1.1:9334,192.168.1.2:9335 -volumeSizeLimitMB=1024 -defaultReplication=100 -mdir=/mnt/weedfs/m2 > m2.log &

nohup weed master -port=9335 -ip=192.168.1.2 -peers=192.168.0.1:9333,192.168.1.1:9334,192.168.1.2:9335 -volumeSizeLimitMB=1024 -defaultReplication=100 -mdir=/mnt/weedfs/m3 > m3.log &
```



#### volume（存储服务器）

```bash
nohup weed volume -ip=192.168.0.10 -port=9222 -dataCenter=dc1 -rack=rc1 -max=0 -mserver=192.168.0.1:9333,192.168.1.1:9334,192.168.1.2:9335 -dir=/seaweed/v1 > v1.log &

nohup weed volume -ip=192.168.1.10 -port=9223 -dataCenter=dc2 -rack=rc1 -max=0 -mserver=192.168.0.1:9333,192.168.1.1:9334,192.168.1.2:9335 -dir=/seaweed/v2 > v2.log &

nohup weed volume -ip=192.168.1.20 -port=9224 -dataCenter=dc2 -rack=rc2 -max=0 -mserver=192.168.0.1:9333,192.168.1.1:9334,192.168.1.2:9335 -dir=/seaweed/v3 > v3.log &
```
- 如果最大逻辑卷数量设置为零`-max = 0`，该限制将自动配置为磁盘可用空间除以卷大小，默认值为：“8”。


#### nginx（代理服务器）

```nginx
upstream volumes {
    server 192.168.0.10:9222;
    server 192.168.1.10:9223;
    server 192.168.1.10:9224;
}

server {

	listen       80;
    server_name  file.example.com;

	location / {
		proxy_pass http://volumes;
    }

}
```

- 可通过volume服务器的参数 `-readMode = proxy`（值：local | proxy | redirect）来设置，默认值为：“proxy”。



### API

#### 上传

直接向master(中央服务器)上传文件，内部自动分配文件ID，命令如下：

```sh
curl -X POST -F file=@/test/1.png http://127.0.0.1:9333/submit?collection=test&ttl=30m&replication=001
```

上传成功返回下面结果：

```json
{
    "fid": "3,01637037d6",
    "fileName": "1.png",
    "fileUrl": "http://127.0.0.1:9222/3,01637037d6",
    "size": 50326
}
```

参数 **ttl** 表示过期时间（单位： **m** [分钟] | **h** [小时] | **d** [天] | **w** [周] | **M** [月] | **y** [年]）



#### 查看

URL可在浏览器中直接打开： 

    http://127.0.0.1:9222/3,01637037d6

URL可访问的等效变种地址：

    http://127.0.0.1:9222/3/01637037d6/myphoto.jpg
    http://127.0.0.1:9222/3/01637037d6.jpg
    http://127.0.0.1:9222/3,01637037d6.jpg
    http://127.0.0.1:9222/3/01637037d6
    http://127.0.0.1:9222/3,01637037d6



#### 缩放

```sh
http://127.0.0.1:9222/11,1af9f35ee7.jpg?width=200&height=200&mode=fit
```

**mode**（值： fit | fill )



#### 覆盖

直接对某个已存在的fileUrl 提交POST 请求，将新文件上传即可，新文件内容自动覆盖老的文件，如：

    curl -X POST -F file=@/2.png http://127.0.0.1:9222/11,1af9f35ee7



返回结果为：

    {
        "name": "2.png",
        "size": 50326
    }



#### 删除

使用文件所在的volume存储服务器地址执行如下命令
```sh
方法一、
curl -X DELETE http://127.0.0.1:9222/11,1af9f35ee7

方法二、
curl -X POST http://127.0.0.1:9222/delete?fid=11,1af9f35ee7

返回值：
[ {  "fid": "11,1af9f35ee7", "size": 50326 } ]
```

**注：** 无返回值或size值为0都为删除失败



#### 断点

断点续传和断点（并发）下载，是通过标准HTTP的ETag, Accept-Range 进行支持，具体参看标准示例。



#### 其他

```sh
一、volume的节点信息
curl http://127.0.0.1:9222/status?pretty=y

二、查看master下volume节点
curl http://127.0.0.1:9333/dir/status?pretty=y

三、查看集群master信息
curl http://127.0.0.1:9333/cluster/status?pretty=y
```
