#!/bin/bash -ex

pwd=$(pwd)
source $pwd/bin/common.sh

__network() {
    gcloud compute networks create $net \
        --project=${project_id}

    gcloud compute networks subnets create $subnet \
        --network=$net \
        --project=${project_id} \
        --range=10.0.0.0/24 \
        --region=us-central1 \
        --enable-private-ip-google-access
}

__gcs() {
    gcloud storage buckets create gs://${gcs_flink} --location=US
}

__main() {
    __network
    __gcs
}

__main $@
