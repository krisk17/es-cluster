#!bin/bash
sysctl -w vm.max_map_count=524288
docker-compose -f create-certs.yml run --rm create_certs
docker-compose up -d
docker run --rm -v es_certs:/certs --network=es_default docker.elastic.co/elasticsearch/elasticsearch:7.5.1 curl --cacert /certs/ca/ca.crt -u elastic:admin123 https://es01:9200
docker exec es01 /bin/bash -c "bin/elasticsearch-setup-passwords \
auto --batch \
-Expack.security.http.ssl.certificate=certificates/es01/es01.crt \
-Expack.security.http.ssl.certificate_authorities=certificates/ca/ca.crt \
-Expack.security.http.ssl.key=certificates/es01/es01.key \
--url https://localhost:9200" 
