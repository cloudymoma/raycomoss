#!/bin/bash -ex

pwd=$(pwd)
source $pwd/bin/common.sh

deployment=dingo-flink
max_slots=4
job_name=dingostream
uuid=$(uuidgen)
min_parallelism=1
max_parallelism=4

FLINK=`which flink`
job_jar=dingostream-1.0-SNAPSHOT.jar
main_class=bindiego.DataStreamJob

__usage() {
    echo "Usage: ./bin/flink.sh {api,deploy,package,run,runlocal}"
}

__enable_api() {
    gcloud services enable managedflink.googleapis.com compute.googleapis.com
}

__gcloud-managed-flink-client() {
    echo "Y" | gcloud components install managed-flink-client
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

__pkg() {
    cd $pwd/src/flink/dingostream && \
        mvn clean package
}

__job() {
    __pkg

    gcloud alpha managed-flink jobs create $pwd/src/flink/dingostream/target/$job_jar \
        --name=$job_name-$uuid \
        --location=$region \
        --deployment=$deployment \
        --project=${project_id} \
        --staging-location=gs://$gcs_flink/jobs/ \
        --min-parallelism=$min_parallelism \
        --max-parallelism=$max_parallelism \
        -- --output gs://$gcs_flink/output/
}

__run_local() {
    __pkg

    $FLINK run -Denv.DINGO_LOG_LEVEL=DEBUG \
        -c $main_class $pwd/src/flink/dingostream/target/$job_jar
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
                __gcloud-managed-flink-client
                ;;
            deploy|d)
                __deploy
                ;;
            package|pkg)
                __pkg
                ;;
            job|run)
                __job
                ;;
            runlocal)
                __run_local
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@
