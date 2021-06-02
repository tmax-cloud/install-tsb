# TemplateServiceBroker 설치 가이드

## 구성 요소 및 버전

- template-operator
    - template관련 CustomResource에 대한 operator
    - latest image: tmaxcloudck/template-operator:0.0.9
    - latest version: 0.0.9

- cluster-tsb
    - clustertemplate을 서비스하는 template-service-broker 모듈
    - Hypercloud 이용자가 공통으로 사용 할 수 있는 template
    - latest image: tmaxcloudck/cluster-tsb:0.0.8
    - latest version: 0.0.8
- tsb
    - template을 서비스하는 template-service-broker 모듈
    - Hypercloud 이용자가 직접 정의해서 사용 할 수 있는 template
    - 사용자 namespace 별로 띄워야 이용 가능
    - latest image: tmaxcloudck/tsb:0.0.8
    - latest version: 0.0.8

## Prerequisites

- TemplateServiceBroker 설치 전, Template operator module이 설치 되어 있어야 합니다.
- service-catalog를 사용하고자 하시는 경우, [install-catalog](https://github.com/tmax-cloud/install-catalog/tree/5.0)를 참고하여 catalogController를 설치해 주세요.
- 폐쇄망에서 설치하는 경우 사용하는 image를 다운받고 저장합니다.
   * [install-registry 이미지 푸시하기 참조](https://github.com/tmax-cloud/install-registry/blob/5.0/podman.md)
## Template-operator install Steps
1. [CRD 생성](#Step-1-Template-operator-CRD-생성)
2. [Namespace 생성](#Step-2-Template-operator-Namespace-생성)
3. [Role 및 RoleBinding 생성](#Step-3-Template-operator-Role-및-RoleBinding-생성)
4. [Deployment 생성](#Step-4-Template-operator-Deployment-생성)
- install script를 통해 설치하실 경우, manifest/README.md를 참고해 주세요.

## Step 1. Template operator CRD 생성
- 목적 : `Template operator CRD 생성`
- 생성 순서 : 아래 command로 yaml 적용
  - kubectl apply -f tmax.io_catalogserviceclaims.yaml ([파일](./manifest/yaml/crd/tmax.io_catalogserviceclaims.yaml))
  - kubectl apply -f tmax.io_clustertemplates.yaml ([파일](./manifest/yaml/crd/tmax.io_clustertemplates.yaml))
  - kubectl apply -f tmax.io_templateinstances.yaml ([파일](./manifest/yaml/crd/tmax.io_templateinstances.yaml))
  - kubectl apply -f tmax.io_templates.yaml ([파일](./manifest/yaml/crd/tmax.io_templates.yaml))

## Step 2. Template operator Namespace 생성
- 목적 : `Template operator namespace 생성`
- 생성 순서 : 아래 command로 yaml 적용
  - kubectl create namespace {YOUR_NAMESPACE}
- 비고: namespace는 template 이라고 가정하고 진행 하겠습니다.

## Step 3. Template operator Role 및 RoleBinding 생성
- 목적 : `Template operator Role 및 RoleBinding 생성`
- 생성 순서 : 아래 command로 yaml 적용
  - kubectl apply -f deploy_rbac.yaml ([파일](./manifest/yaml/template-operator/deploy_rbac.yaml))
- 비고: 반드시, {templateNamespace}를 사용자가 정한 namespace로 변경해주세요.

## Step 4. Template operator Deployment 생성
- 목적 : `Template operator Deployment 생성`
- 생성 순서 : 아래 command로 yaml 적용
  - kubectl apply -f deploy_manager.yaml ([파일](./manifest/yaml/template-operator/deploy_manager.yaml))
- 비고: 반드시, {templateNamespace}를 사용자가 정한 namespace로 변경해주세요.
- 비고: image 항목의 {imageRegistry}와 {templateOperatorVersion}를 환경에 맞게 변경해주세요. ({imageRegistry}/tmaxcloudck/template-operator:{templateOperatorVersion})

## Cluster-tsb install Steps
1. [Namespace 및 ServiceAccount 생성](#Step-1-Cluster-tsb-Namespace-및-ServiceAccount-생성)
2. [Role 및 RoleBinding 생성](#Step-2-Cluster-tsb-Role-및-RoleBinding-생성)
3. [TemplateServiceBroker 생성](#Step-3-Cluster-tsb-Server-생성)
4. [TemplateServiceBroker Service 생성](#Step-4-Cluster-tsb-Service-생성)
5. [TemplateServiceBroker 등록](#Step-5-Cluster-tsb-Broker-등록)
- install script를 통해 설치하실 경우, manifest/README.md를 참고해 주세요.

## Step 1. Cluster-tsb Namespace 및 ServiceAccount 생성
- 목적 : `Namespace 및 ServiceAccount 생성.`
- 생성 순서 : 아래 command로 yaml 적용
  - kubectl create namespace cluster-tsb-ns
  - kubectl apply -f tsb_serviceaccount.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_serviceaccount.yaml))

## Step 2. Cluster-tsb Role 및 RoleBinding 생성
- 목적 : `해당 namespace의 serviceaccount에 권한 부여.`
- 생성 순서 : 아래 command로 yaml 적용
  - (serviceaccount: cluster-tsb-sa라고 가정)
  - kubectl apply -f tsb_role.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_role.yaml))
  - kubectl apply -f tsb_rolebinding.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_rolebinding.yaml))

## Step 3. Cluster-tsb Server 생성
- 목적 : `TemplateServiceBroker Server deploy 및 서비스 계정 마운트.`
- 생성 순서 : 아래 commmand로 yaml 적용
  - (serviceaccount: cluster-tsb-sa라고 가정)
  - kubectl apply -f tsb_deployment.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_deployment.yaml))
- 비고 : 파일의 {imageRegistry}, {clusterTsbVersion} 부분은 사용자 환경에 맞게 변경 해주셔야 합니다.

## Step 4. Cluster-tsb Service 생성
- 목적 : `server에 접속하기 위한 endpoint 생성.`
- 생성 순서 : 아래 commmand로 yaml 적용
  - kubectl apply -f tsb_service.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_service.yaml))

## Step 5. Cluster-tsb Broker 등록
- 목적 : `TemplateServiceBroker 등록.`
- 생성 순서 : 아래 commmand로 yaml 적용
  - kubectl apply -f tsb_service_broker.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_service_broker.yaml))
- 비고 : clustser-tsb server 정상 기동 확인 후, 등록해주세요.


## Tsb install Steps

1. [Namespace 및 ServiceAccount 생성](#Step-1-Tsb-Namespace-및-ServiceAccount-생성)
2. [Role 및 RoleBinding 생성](#Step-2-Tsb-Role-및-RoleBinding-생성)
3. [TemplateServiceBroker 생성](#Step-3-Tsb-Server-생성)
4. [TemplateServiceBroker Service 생성](#Step-4-Tsb-Service-생성)
5. [TemplateServiceBroker 등록](#Step-5-Tsb-Broker-등록)
- install script를 통해 설치하실 경우, manifest/README.md를 참고해 주세요.

## Step 1. Tsb Namespace 및 ServiceAccount 생성
- 목적 : `Namespace 및 ServiceAccount 생성.`
- 생성 순서 : 아래 command로 yaml 적용
  - {tsbNamespace}는 사용자 자신의 namespace를 의미합니다.
  - kubectl create namespace {tsbNamespace}
  - kubectl apply -f tsb_serviceaccount.yaml ([파일](./manifest/yaml/tsb/tsb_serviceaccount.yaml))
- 비고 : 파일내부 {tsbNamespace}는 사용자에 맞게 변경해야 합니다.

## Step 2. Tsb Role 및 RoleBinding 생성
- 목적 : `해당 namespace의 serviceaccount에 권한 부여.`
- 생성 순서 : 아래 command로 yaml 적용
  - kubectl apply -f tsb_role.yaml ([파일](./manifest/yaml/tsb/tsb_role.yaml))
  - kubectl apply -f tsb_rolebinding.yaml ([파일](./manifest/yaml/tsb/tsb_rolebinding.yaml))
- 비고 : 파일내부 {tsbNamespace}는 사용자에 맞게 변경해야 합니다.

## Step 3. Tsb Server 생성
- 목적 : `TemplateServiceBroker Server deploy 및 서비스 계정 마운트.`
- 생성 순서 : 아래 commmand로 yaml 적용
  - kubectl apply -f tsb_deployment.yaml ([파일](./manifest/yaml/tsb/tsb_deployment.yaml))
- 비고 : 파일내부 {tsbNamespace}는 사용자에 맞게 변경해야 합니다.
- 비고 : image 항목은 {imageRegistry}와 {tsbVersion}은 사용자 환경에 맞게 변경해야 합니다. ({imageRegistry}/tmaxcloudck/tsb:{tsbVersion})

## Step 4. Tsb Service 생성
- 목적 : `server에 접속하기 위한 endpoint 생성.`
- 생성 순서 : 아래 commmand로 yaml 적용
  - kubectl apply -f tsb_service.yaml ([파일](./manifest/yaml/tsb/tsb_service.yaml))
- 비고 : 파일내부 {tsbNamespace}는 사용자에 맞게 변경해야 합니다.

## Step 5. Tsb Broker 등록
- 목적 : `TemplateServiceBroker 등록.`
- 생성 순서 : 아래 commmand로 yaml 적용
  - {YOUR_NAMESPACE}는 사용자 자신의 namespace를 의미합니다.
  - kubectl apply -f tsb_service_broker.yaml ([파일](./manifest/yaml/tsb/tsb_service_broker.yaml))
- 비고 : 파일내부 {tsbNamespace}는 사용자에 맞게 변경해야 합니다.


## Template-operator uninstall Steps
- 설치 역순으로 진행 (차례대로 아래와 같은 yaml 적용)
  1. kubectl delete -f deploy_manager.yaml ([파일](./manifest/yaml/template-operator/deploy_manager.yaml))
  2. kubectl delete -f deploy_rbac.yaml ([파일](./manifest/yaml/template-operator/deploy_rbac.yaml))
  3. kubectl delete namespace {templateNamespace}
  4. kubectl delete -f tmax.io_templates.yaml ([파일](./manifest/yaml/crd/tmax.io_templates.yaml)
  5. kubectl delete -f tmax.io_templateinstances.yaml ([파일](./manifest/yaml/crd/tmax.io_templateinstances.yaml))
  6. kubectl delete -f tmax.io_clustertemplates.yaml ([파일](./manifest/yaml/crd/tmax.io_clustertemplates.yaml))
  7. kubectl delete -f tmax.io_catalogserviceclaims.yaml ([파일](./manifest/yaml/crd/tmax.io_catalogserviceclaims.yaml))

## Cluster-tsb uninstall Steps
- 설치 역순으로 진행 (차례대로 아래와 같은 yaml 적용)
  1. kubectl delete -f tsb_service_broker.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_service_broker.yaml))
  2. kubectl delete -f tsb_service.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_service.yaml))
  3. kubectl delete -f tsb_deployment.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_deployment.yaml))
  4. kubectl delete -f tsb_rolebinding.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_rolebinding.yaml))
  5. kubectl delete -f tsb_role.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_role.yaml))
  6. kubectl delete -f tsb_serviceaccount.yaml ([파일](./manifest/yaml/cluster-tsb/tsb_serviceaccount.yaml))

## Tsb uninstall Steps
- 설치 역순으로 진행 (차례대로 아래와 같은 yaml 적용)
  1. kubectl delete -f tsb_service_broker.yaml ([파일](./manifest/yaml/tsb/tsb_service_broker.yaml))
  2. kubectl delete -f tsb_service.yaml ([파일](./manifest/yaml/tsb/tsb_service.yaml))
  3. kubectl delete -f tsb_deployment.yaml ([파일](./manifest/yaml/tsb/tsb_deployment.yaml))
  4. kubectl delete -f tsb_rolebinding.yaml ([파일](./manifest/yaml/tsb/tsb_rolebinding.yaml))
  5. kubectl delete -f tsb_role.yaml ([파일](./manifest/yaml/tsb/tsb_role.yaml))
  6. kubectl delete -f tsb_serviceaccount.yaml ([파일](./manifest/yaml/tsb/tsb_serviceaccount.yaml))
