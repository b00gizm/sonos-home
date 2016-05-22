#!/usr/bin/env bash

function command-wait {
    retries=$2;
    cnt=0;
    echo "[INFO] Waiting for command '$1' (retries = $retries)"
    while [ $cnt -lt $retries ]
    do
        echo -n "."
        eval "$1" &> /dev/null
        result=$?

        if [ "$result" -lt 1 ]; then
            echo ""
            echo "[INFO] Command was successful"
            sleep 2
            return 0
        fi
        ((cnt++));
        sleep 1
    done
    echo "\n"
    eval "$1"
    echo "[ERR] Command was not successful in time ($retries retries)."
    return 1
}

function kubernetes-wait {
    command-wait "kubectl --namespace=$1 get pods --no-headers | (! egrep '0/1')" ${2:-7200}
    result=$?
    if [ "$result" -ge 1 ]; then
        echo ""
        echo "[ERR] Command was not successful"

        echo "[INFO] See error logs of failed containers below"
        kubectl --namespace=$1 get pods --no-headers
        kubectl --namespace=$1 get pods --no-headers | (! egrep '0/\d+') | awk '{print $1}' | xargs kubectl --namespace=$1 logs

        echo "[DEBUG] Printing out all events in namespace for debugging:"
        echo "[DEBUG] kubectl --namespace=$1 get events"
        kubectl --namespace=$1 get events

        stop $1
        exit $result
    fi
}

function kubernetes-create-namespace {
    echo "{\"apiVersion\": \"v1\", \"kind\": \"Namespace\", \"metadata\": {\"name\": \"$1\", \"labels\": {\"longRunning\": \"false\"}}}" | kubectl create -f -

}

function kubernetes-has-namespace {
    kubectl get namespaces | grep -qs $1
}

function kubernetes-delete-namespace {
    while (kubernetes-has-namespace $1); do
        kubectl delete namespace $1 &> /dev/null
        sleep 1
    done
}

function kubernetes-info {
    echo ""
    echo ">> RUNNING!"
    echo ">>"
    echo ">> kubectl get po --namespace=$1"
    echo ">> kubectl get rc --namespace=$1"
    echo ">> kubectl describe svc --namespace=$1"
    echo ">>"
    echo ">> CALL:"
    echo ">> http://$2"
}
