#!/bin/bash -ex

# cluster parameters
project_id=du-hast-mich
cluster_name=dingo-kafka
region=us-central1
cpu=3 #vCPU
mem=4 #GB
net=default
subnet=default

# topic parameters
topic_id=dingo-topic
topic_partitions=3
topic_rep_factor=2
topic_config=compression.type=producer

__usage() {
    echo "Usage: ./bin/kafka.sh {create|(delete,del,d)|monitor <opration id>|(list,ls,l)|view}"
}

# code for kafka cluster
__create() {
    gcloud beta managed-kafka clusters create "${cluster_name}" \
        --location="${region}" \
        --cpu=$cpu \
        --memory="${mem}GB" \
        --subnets="projects/${project_id}/regions/${region}/subnetworks/${subnet}" \
        --auto-rebalance \
        --async
}

__check() {
    curl -X GET \
        -H "Authorization: Bearer $(gcloud auth print-access-token)" \
        "https://managedkafka.googleapis.com/v1/projects/${project_id}/locations/${region}/operations/$2"
}

__list() {
    gcloud beta managed-kafka clusters list --location=$region \
        --limit=10
}

__view() {
    gcloud beta managed-kafka clusters describe $cluster_name \
        --location=$region
}

__update() {
    gcloud beta managed-kafka clusters update "${cluster_name}" \
        --location="${region}" \
        --cpu=$cpu \
        --memory="12GB" \
        --subnets="projects/${project_id}/regions/${region}/subnetworks/${subnet}" \
        --auto-rebalance \
        --async
}

__delete() {
    gcloud beta managed-kafka clusters delete $cluster_name \
        --location=$region
}

# Code for topic
__topic() {
    gcloud beta managed-kafka topics create ${topic_id} \
        --cluster=${cluster_name} --location=${region} \
        --partitions=${topic_partitions} \
        --replication-factor=${topic_rep_factor} \
        --configs=${topic_config}
}

__topic_ls() {
    gcloud beta managed-kafka topics describe ${topic_id} \
        --cluster=${cluster_name} --location=${region}
}

__topic_update() {
    gcloud beta managed-kafka topics update ${topic_id} \
        --cluster=${cluster_name} \
        --location=${region} \
        --partitions=${topic_partitions} \
        --configs=${topic_config}
}

__topic_del() {
    gcloud beta managed-kafka topics delete ${topic_id} \
        --cluster=${cluster_name} \
        --location=${region}
}

__main() {
    if [ $# -eq 0 ]
    then 
        __usage
    else
        case $1 in 
            create|c)
                __create
                ;;
            monitor|check)
                __check $2
                ;;
            list|ls|l)
                __list
                ;;
            view)
                __view
                ;;
            update)
                __update
                ;;
            delete|del|d)
                __delete
                ;;
            topic)
                __topic
                ;;
            topicls)
                __topic_ls
                ;;
            topicup)
                __topic_update
                ;;
            topicdel)
                __topic_del
                ;;
            *)
                __usage
                ;;
        esac
    fi
}

__main $@
