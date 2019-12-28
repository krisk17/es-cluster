#!bin/bash
sysctl -w vm.max_map_count=524288
docker-compose -f create-certs.yml run --rm create_certs
docker-compose up -d
sleep 30
docker run --rm -v es_certs:/certs --network=es_default docker.elastic.co/elasticsearch/elasticsearch:7.5.1 curl --cacert /certs/ca/ca.crt -u elastic:admin123 https://es01:9200
