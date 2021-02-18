#!/bin/bash

install_dir=$(dirname "$0")
. ${install_dir}/tsb.config
yaml_dir="${install_dir}/yaml"


function set_env(){
    echo "========================================================================="
    echo "======================== set env for tsb  ========================"
    echo "========================================================================="
    if [[ -z ${imageRegistry} ]]; then
        imageRegistry=tmaxcloudck
    else
        imageRegistry=${imageRegistry}
    fi

    if [[ -z ${tsbVersion} ]]; then
        tsbVersion=4.0.0.6
    else
        tsbVersion=${tsbVersion}
    fi

    if [[ -z ${tsbNamespace} ]]; then
        tsbNamespace=tsb-ns
    else
        tsbNamespace=${tsbNamespace}
    fi

    #0. change variable
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_cluster_rolebinding.yaml
    sed -i "s|{imageRegistry}|${imageRegistry}|g" ${yaml_dir}/tsb_deployment.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_deployment.yaml
    sed -i "s|{tsbVersion}|${tsbVersion}|g" ${yaml_dir}/tsb_deployment.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_role.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_rolebinding.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_service_broker.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_service.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${yaml_dir}/tsb_serviceaccount.yaml
}

function install_tsb() {
    echo  "========================================================================="
    echo  "=======================  start install tsb  ======================"
    echo  "========================================================================="
    
    #1. create namespace & serviceaccount
    kubectl create namespace ${tsbNamespace}
    kubectl apply -f ${yaml_dir}/tsb_serviceaccount.yaml

    #2. create role & rolebinding
    kubectl apply -f ${yaml_dir}/tsb_role.yaml
    kubectl apply -f ${yaml_dir}/tsb_cluster_role.yaml
    kubectl apply -f ${yaml_dir}/tsb_rolebinding.yaml
    kubectl apply -f ${yaml_dir}/tsb_cluster_rolebinding.yaml

    #3. create tsb server
    kubectl apply -f ${yaml_dir}/tsb_deployment.yaml

    #4. create tsb service
    kubectl apply -f ${yaml_dir}/tsb_service.yaml

    echo  "========================================================================="
    echo  "======================  complete install tsb  ===================="
    echo  "========================================================================="
}

function register_tsb(){
    echo  "========================================================================="
    echo  "=======================  start install tsb  ======================"
    echo  "========================================================================="
    #1. register tsb
    kubectl apply -f ${yaml_dir}/tsb_service_broker.yaml
    echo  "========================================================================="
    echo  "======================  register tsb  ===================="
    echo  "========================================================================="
}

function uninstall_tsb(){
    echo  "========================================================================="
    echo  "=======================  start uninstall tsb  ======================"
    echo  "========================================================================="
    kubectl delete -f ${yaml_dir}/tsb_service_broker.yaml
    kubectl delete -f ${yaml_dir}/tsb_service.yaml
    kubectl delete -f ${yaml_dir}/tsb_deployment.yaml
    kubectl delete -f ${yaml_dir}/tsb_cluster_rolebinding.yaml
    kubectl delete -f ${yaml_dir}/tsb_rolebinding.yaml
    kubectl delete -f ${yaml_dir}/tsb_cluster_role.yaml
    kubectl delete -f ${yaml_dir}/tsb_role.yaml
    kubectl delete -f ${yaml_dir}/tsb_serviceaccount.yaml
    kubectl delete namespace ${tsbNamespace}
    echo  "========================================================================="
    echo  "======================  complete uninstall tsb  ===================="
    echo  "========================================================================="
}

function main(){
    case "${1:-}" in
    install)
        set_env
        install_tsb
        ;;
    uninstall)
        set_env
        uninstall_tsb
        ;;
    register)
        set_env
        register_tsb
        ;;
    *)
        set +x
        echo " service list:" >&2
        echo "  $0 install" >&2
        echo "  $0 uninstall" >&2
        echo "  $0 register" >&2
        ;;
    esac
}

main $1