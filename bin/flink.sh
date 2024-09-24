#!/bin/bash -ex

pwd=$(pwd)
source $pwd/bin/common.sh

deployment=dingo-flink
max_slots=4

__usage() {
    echo "Usage: ./bin/flink.sh deploy"
}

__enable_api() {
    gcloud services enable managedflink.googleapis.com compute.googleapis.com
}

__deploy() {
    gcloud alpha managed-flink deployments create $deployment \
        --project=${project_id} \
        --location=$region \
        --network-config-vpc=$net \
        --network-config-subnetwork=$subnet \
        --max-slots=$max_slots
}

__main() {
    if [ $# -eq 0 ]
    then 
        __usage
    else
        case $1 in 
            api)
                __enable_api
                ;;
            deploy|d)
                __deploy
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@
