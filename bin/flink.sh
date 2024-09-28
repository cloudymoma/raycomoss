#!/bin/bash -ex

pwd=$(pwd)
source $pwd/bin/common.sh

deployment=dingo-flink
max_slots=4
job_name=dingo_wordcount
uuid=$(uuidgen)
min_parallelism=1
max_parallelism=4

__usage() {
    echo "Usage: ./bin/flink.sh deploy"
}

__enable_api() {
    gcloud services enable managedflink.googleapis.com compute.googleapis.com
}

__gcs_permission() {
    gcloud storage buckets add-iam-policy-binding gs://${gcs_flink} \
        --member="serviceAccount:gmf-${project_num}-default@gcp-sa-managedflink-wi.iam.gserviceaccount.com" \
        --role=roles/storage.objectAdmin
}

__deploy() {
    gcloud alpha managed-flink deployments create $deployment \
        --project=${project_id} \
        --location=$region \
        --network-config-vpc=$net \
        --network-config-subnetwork=$subnet \
        --max-slots=$max_slots
}

__job() {
    gcloud alpha managed-flink jobs create $pwd/lib/WordCount.jar \
        --name=$job_name-$uuid \
        --location=$region \
        --deployment=$deployment \
        --project=${project_id} \
        --staging-location=gs://$gcs_flink/jobs/ \
        --min-parallelism=$min_parallelism \
        --max-parallelism=$max_parallelism \
        -- --output gs://$gcs_flink/output/
}

__main() {
    if [ $# -eq 0 ]
    then 
        __usage
    else
        case $1 in 
            api)
                __enable_api
                __gcs_permission
                ;;
            deploy|d)
                __deploy
                ;;
            job|run)
                __job
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@
