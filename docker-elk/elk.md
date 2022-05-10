

### ElasticSearch

```sh
docker run -d --restart always --name es_honghe1 \
    -p 7200:9200 -p 7300:9300 \
    -e TZ="Asia/Shanghai" \
    -e ES_JAVA_OPTS="-Xms4g -Xmx4g" \
    -e ELASTIC_PASSWORD="Password-2020" \
    -v $(pwd)/elasticsearch/data:/usr/share/elasticsearch/data \
    -v $(pwd)/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro \
    --ulimit memlock=-1:-1 \
    docker.elastic.co/elasticsearch/elasticsearch:7.1.1
```



### Kibana

```sh
docker run -it -d --restart always --name kibana \
    -p 7400:5601 \
    -e TZ="Asia/Shanghai" \
    -v $(pwd)/kibana/config/kibana.yml:/usr/share/kibana/config/kibana.yml:ro \
    docker.elastic.co/kibana/kibana:7.1.1
```



### Logstash

```sh
docker run -it -d --restart always --name logstash \
    -p 7500:5000 -p 7600:9600 \
    -e TZ="Asia/Shanghai" \
    -e LS_JAVA_OPTS="-Xms2g -Xmx2g -XX:-AssumeMP" \
    -v $(pwd)/logstash/data:/usr/share/logstash/data \
    -v $(pwd)/logstash/lib/mysql-connector-java-8.0.15.jar:/usr/share/logstash/lib/mysql-connector-java-8.0.15.jar \
    -v $(pwd)/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro \
    -v $(pwd)/logstash/config/pipelines.yml:/usr/share/logstash/config/pipelines.yml:ro \
    -v $(pwd)/logstash/pipeline:/usr/share/logstash/pipeline:ro \
    docker.elastic.co/logstash/logstash:7.1.1
```



### 部署到一台

```sh
 docker run -d --restart always --name es_node1 \
     -p 7200:9200 -p 7300:9300 -p 7400:5601 -p 7500:5000 -p 7600:9600 \
     -e TZ="Asia/Shanghai" \
     -e ES_JAVA_OPTS="-Xms4g -Xmx4g" \
     -e ELASTIC_PASSWORD="Password-2020" \
     -v $(pwd)/elasticsearch/data:/usr/share/elasticsearch/data \
     -v $(pwd)/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml:ro \
     --ulimit memlock=-1:-1 \
     docker.elastic.co/elasticsearch/elasticsearch:7.1.1

docker run -it -d --restart always --name kibana \
    --network=container:es_node1 \
    -e TZ="Asia/Shanghai" \
    -v $(pwd)/kibana/config/kibana.yml:/usr/share/kibana/config/kibana.yml:ro \
    docker.elastic.co/kibana/kibana:7.1.1

docker run -it -d --restart always --name logstash \
    --network=container:es_node1 \
    -e TZ="Asia/Shanghai" \
    -e LS_JAVA_OPTS="-Xms1g -Xmx1g -XX:-AssumeMP" \
    -v $(pwd)/logstash/data:/usr/share/logstash/data \
    -v $(pwd)/logstash/lib/mysql-connector-java-8.0.15.jar:/usr/share/logstash/lib/mysql-connector-java-8.0.15.jar \
    -v $(pwd)/logstash/config/logstash.yml:/usr/share/logstash/config/logstash.yml:ro \
    -v $(pwd)/logstash/config/pipelines.yml:/usr/share/logstash/config/pipelines.yml:ro \
    -v $(pwd)/logstash/pipeline:/usr/share/logstash/pipeline:ro \
    docker.elastic.co/logstash/logstash:7.1.1
```





在`ElasticSearch7.0`之前`xpack`的安全组件是收费的，所以需要禁用`xpack.security.enabled = false`

```sh
docker run -d  --restart always --name es_node1 \
    -p 7200:9200 -p 7300:9300 -p 7600:5601 \
    -e cluster.name=escluster \
    -e http.host=0.0.0.0 \
    -e transport.host=127.0.0.1 \
    -e ES_JAVA_OPTS="-Xms2g -Xmx2g" \
    -e xpack.security.enabled=false \
    -v $(pwd)/elasticsearch/data:/usr/share/elasticsearch/data \
    docker.elastic.co/elasticsearch/elasticsearch:6.4.2


docker run -it -d --name kibana \
    --network=container:es_node1 \
    -e ELASTICSEARCH_URL=http://127.0.0.1:9200 \
    -e xpack.security.enabled=false \
    docker.elastic.co/kibana/kibana:6.4.2
```

