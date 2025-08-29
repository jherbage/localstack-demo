# localstack-demo

Simple demo in docker of terraform provisioning a very simple AWS lambda backed REST API in [localstack](https://www.localstack.cloud/)'s community edition.

* install [docker](https://docs.docker.com/engine/install/) and [docker-compose](https://docs.docker.com/compose/install/)
* `docker-compose up -d`
* Hit [this](http://myid123.execute-api.localhost.localstack.cloud:4566/v1/myapi) to see a response of 
```
Hello, <your IP>
```
* Note that the first execution is slow as the lambda is loaded