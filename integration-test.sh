#!/bin/bash

#integration-test.sh

sleep 5s

PORT=$(kubectl -n default get svc ${devsecops-svcc } -o json | jq .spec.ports[].nodePort)

echo $PORT

if [[ ! -z "$PORT" ]];
then

    response=$(curl -s  http://20.58.188.143:$PORT$)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" http://20.58.188.143:$PORT$)

  

    if [[ "$http_code" == 200 ]];
        then
            echo "HTTP Status Code Test Passed"
        else
            echo "HTTP Status code is not 200"
            exit 1;
    fi;

else
        echo "The Service does not have a NodePort"
        exit 1;
fi;
