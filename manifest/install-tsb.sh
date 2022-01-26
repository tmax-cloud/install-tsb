#!/bin/bash

install_dir=$(dirname "$0")
. ${install_dir}/tsb.config
yaml_dir="${install_dir}/yaml"
crd_dir="${yaml_dir}/crd/key-mapping"
template_dir="${yaml_dir}/template-operator"
cluster_tsb_dir="${yaml_dir}/cluster-tsb"
tsb_dir="${yaml_dir}/tsb"

function set_env(){
    echo "========================================================================="
    echo "======================== set env  ========================"
    echo "========================================================================="
    if [[ -z ${imageRegistry} ]]; then
        imageRegistry=docker.io
    else
        imageRegistry=${imageRegistry}
    fi

    if [[ -z ${templateOperatorVersion} ]]; then
        templateOperatorVersion=0.2.7
    else
        templateOperatorVersion=${templateOperatorVersion}
    fi

    if [[ -z ${templateNamespace} ]]; then
        templateNamespace=template
    else
        templateNamespace=${templateNamespace}
    fi

    if [[ -z ${clusterTsbVersion} ]]; then
        clusterTsbVersion=0.1.3
    else
        clusterTsbVersion=${clusterTsbVersion}
    fi

    if [[ -z ${tsbVersion} ]]; then
        tsbVersion=0.1.3
    else
        tsbVersion=${tsbVersion}
    fi

    if [[ -z ${clusterTsbNamespace} ]]; then
        clusterTsbNamespace=cluster-tsb-ns
    else
        clusterTsbNamespace=${clusterTsbNamespace}
    fi

    if [[ -z ${tsbNamespace} ]]; then
        tsbNamespace=tsb-ns
    else
        tsbNamespace=${tsbNamespace}
    fi

    #0. change variable
    sed -i "s|{templateNamespace}|${templateNamespace}|g" ${template_dir}/deploy_rbac.yaml
    sed -i "s|{templateNamespace}|${templateNamespace}|g" ${template_dir}/deploy_manager.yaml
    sed -i "s|{imageRegistry}|${imageRegistry}|g" ${template_dir}/deploy_manager.yaml
    sed -i "s|{templateOperatorVersion}|${templateOperatorVersion}|g" ${template_dir}/deploy_manager.yaml

    sed -i "s|{imageRegistry}|${imageRegistry}|g" ${cluster_tsb_dir}/tsb_deployment.yaml
    sed -i "s|{clusterTsbNamespace}|${clusterTsbNamespace}|g" ${cluster_tsb_dir}/tsb_deployment.yaml
    sed -i "s|{clusterTsbVersion}|${clusterTsbVersion}|g" ${cluster_tsb_dir}/tsb_deployment.yaml
    sed -i "s|{clusterTsbNamespace}|${clusterTsbNamespace}|g" ${cluster_tsb_dir}/tsb_rolebinding.yaml
    sed -i "s|{clusterTsbNamespace}|${clusterTsbNamespace}|g" ${cluster_tsb_dir}/tsb_service_broker.yaml
    sed -i "s|{clusterTsbNamespace}|${clusterTsbNamespace}|g" ${cluster_tsb_dir}/tsb_service.yaml
    sed -i "s|{clusterTsbNamespace}|${clusterTsbNamespace}|g" ${cluster_tsb_dir}/tsb_serviceaccount.yaml

    sed -i "s|{imageRegistry}|${imageRegistry}|g" ${tsb_dir}/tsb_deployment.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${tsb_dir}/tsb_deployment.yaml
    sed -i "s|{tsbVersion}|${tsbVersion}|g" ${tsb_dir}/tsb_deployment.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${tsb_dir}/tsb_role.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${tsb_dir}/tsb_rolebinding.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${tsb_dir}/tsb_service_broker.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${tsb_dir}/tsb_service.yaml
    sed -i "s|{tsbNamespace}|${tsbNamespace}|g" ${tsb_dir}/tsb_serviceaccount.yaml
}

function install_template() {
    echo  "========================================================================="
    echo  "=======================  start install template  ======================"
    echo  "========================================================================="
    #1. create crd
    kubectl apply -f ${crd_dir}/tmax.io_clustertemplateclaims.yaml
    kubectl apply -f ${crd_dir}/tmax.io_clustertemplates.yaml
    kubectl apply -f ${crd_dir}/tmax.io_templateinstances.yaml
    kubectl apply -f ${crd_dir}/tmax.io_templates.yaml
    #2. create namespace
    kubectl create namespace ${templateNamespace}
    #3. create role & rolebinding
    kubectl apply -f ${template_dir}/deploy_rbac.yaml
    #4. create deployment
    kubectl apply -f ${template_dir}/deploy_manager.yaml
    echo  "========================================================================="
    echo  "=======================  complete install template  ======================"
    echo  "========================================================================="
}

function install_cluster_tsb(){
    echo  "========================================================================="
    echo  "=======================  start cluster tsb  ======================"
    echo  "========================================================================="
    #1. create namespace & serviceaccount
    kubectl create namespace ${clusterTsbNamespace}
    kubectl apply -f ${cluster_tsb_dir}/tsb_serviceaccount.yaml

    #2. create role & rolebinding
    kubectl apply -f ${cluster_tsb_dir}/tsb_role.yaml
    kubectl apply -f ${cluster_tsb_dir}/tsb_rolebinding.yaml

    #3. create tsb server
    kubectl apply -f ${cluster_tsb_dir}/tsb_deployment.yaml

    #4. create tsb service
    kubectl apply -f ${cluster_tsb_dir}/tsb_service.yaml

    echo  "========================================================================="
    echo  "=======================  complete install cluster tsb  ======================"
    echo  "========================================================================="
}


function install_tsb() {
    echo  "========================================================================="
    echo  "=======================  start install tsb  ======================"
    echo  "========================================================================="
    
    #1. create namespace & serviceaccount
    kubectl create namespace ${tsbNamespace}
    kubectl apply -f ${tsb_dir}/tsb_serviceaccount.yaml

    #2. create role & rolebinding
    kubectl apply -f ${tsb_dir}/tsb_role.yaml
    kubectl apply -f ${tsb_dir}/tsb_rolebinding.yaml

    #3. create tsb server
    kubectl apply -f ${tsb_dir}/tsb_deployment.yaml

    #4. create tsb service
    kubectl apply -f ${tsb_dir}/tsb_service.yaml

    echo  "========================================================================="
    echo  "======================  complete install tsb  ===================="
    echo  "========================================================================="
}

function register_cluster_tsb(){
    echo  "========================================================================="
    echo  "=======================  start register cluster tsb  ======================"
    echo  "========================================================================="
    kubectl apply -f ${cluster_tsb_dir}/tsb_service_broker.yaml
    echo  "========================================================================="
    echo  "======================  complete register cluster tsb  ===================="
    echo  "========================================================================="
}

function register_tsb(){
    echo  "========================================================================="
    echo  "=======================  start register tsb  ======================"
    echo  "========================================================================="
    kubectl apply -f ${tsb_dir}/tsb_service_broker.yaml
    echo  "========================================================================="
    echo  "======================  complete register tsb  ===================="
    echo  "========================================================================="
}

function uninstall_template(){
    echo  "========================================================================="
    echo  "=======================  start uninstall template  ======================"
    echo  "========================================================================="
    kubectl delete -f ${template_dir}/deploy_manager.yaml
    kubectl delete -f ${template_dir}/deploy_rbac.yaml
    kubectl delete namespace ${templateNamespace}
    kubectl delete -f ${crd_dir}/tmax.io_clustertemplateclaims.yaml
    kubectl delete -f ${crd_dir}/tmax.io_clustertemplates.yaml
    kubectl delete -f ${crd_dir}/tmax.io_templateinstances.yaml
    kubectl delete -f ${crd_dir}/tmax.io_templates.yaml
    echo  "========================================================================="
    echo  "=======================  complete uninstall template  ======================"
    echo  "========================================================================="
}

function uninstall_cluster_tsb(){
    echo  "========================================================================="
    echo  "=======================  start uninstall cluster tsb  ======================"
    echo  "========================================================================="
    kubectl delete -f ${cluster_tsb_dir}/tsb_service.yaml
    kubectl delete -f ${cluster_tsb_dir}/tsb_deployment.yaml
    kubectl delete -f ${cluster_tsb_dir}/tsb_rolebinding.yaml
    kubectl delete -f ${cluster_tsb_dir}/tsb_role.yaml
    kubectl delete -f ${cluster_tsb_dir}/tsb_serviceaccount.yaml
    kubectl delete namespace ${clusterTsbNamespace}
    echo  "========================================================================="
    echo  "=======================  complete uninstall cluster tsb  ======================"
    echo  "========================================================================="
}

function uninstall_tsb(){
    echo  "========================================================================="
    echo  "=======================  start uninstall tsb  ======================"
    echo  "========================================================================="
    kubectl delete -f ${tsb_dir}/tsb_service.yaml
    kubectl delete -f ${tsb_dir}/tsb_deployment.yaml
    kubectl delete -f ${tsb_dir}/tsb_rolebinding.yaml
    kubectl delete -f ${tsb_dir}/tsb_role.yaml
    kubectl delete -f ${tsb_dir}/tsb_serviceaccount.yaml
    kubectl delete namespace ${tsbNamespace}
    echo  "========================================================================="
    echo  "======================  complete uninstall tsb  ===================="
    echo  "========================================================================="
}

function unregister_cluster_tsb(){
    echo  "========================================================================="
    echo  "=======================  start unregister cluster tsb  ======================"
    echo  "========================================================================="
    kubectl delete -f ${cluster_tsb_dir}/tsb_service_broker.yaml
    echo  "========================================================================="
    echo  "======================  complete unregister cluster tsb  ===================="
    echo  "========================================================================="
}

function unregister_tsb(){
    echo  "========================================================================="
    echo  "=======================  start unregister tsb  ======================"
    echo  "========================================================================="
    kubectl delete -f ${tsb_dir}/tsb_service_broker.yaml
    echo  "========================================================================="
    echo  "======================  complete register tsb  ===================="
    echo  "========================================================================="
}

function main(){
    case "${1:-}" in
    install-template)
        set_env
        install_template
        ;;
    uninstall-template)
        set_env
        uninstall_template
        ;;
    install-cluster-tsb)
        set_env
        install_cluster_tsb
        ;;
    uninstall-cluster-tsb)
        set_env
        uninstall_cluster_tsb
        ;;
    install-tsb)
        set_env
        install_tsb
        ;;
    uninstall-tsb)
        set_env
        uninstall_tsb
        ;;
    register-cluster-tsb)
        set_env
        register_cluster_tsb
        ;;
    unregister-cluster-tsb)
        set_env
        unregister_cluster_tsb
        ;;
    register-tsb)
        set_env
        register_tsb
        ;;
    unregister-tsb)
        set_env
        unregister_tsb
        ;;
    *)
        set +x
        echo " service list:" >&2
        echo "  $0 install-template" >&2
        echo "  $0 uninstall-template" >&2
        echo "  $0 install-cluster-tsb" >&2
        echo "  $0 uninstall-cluster-tsb" >&2
        echo "  $0 install-tsb" >&2
        echo "  $0 uninstall-tsb" >&2
        echo "  $0 register-cluster-tsb" >&2
        echo "  $0 unregister-cluster-tsb" >&2
        echo "  $0 register-tsb" >&2
        echo "  $0 unregister-tsb" >&2
        ;;
    esac
}

main $1
