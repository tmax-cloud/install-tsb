# tsb installer 사용법

## Prerequisites
  - 해당 installer는 폐쇄망 기준 가이드입니다.
  - image registry에 이미지를 push 합니다. (Prerequisites 참고)
    - https://github.com/tmax-cloud/install-tsb/tree/tsb-5.0

## Step0. tsb.config 설정
- 목적 : `tsb 설치 진행을 위한 tsb config 설정`
- 순서 : 
  - 환경에 맞는 config 내용을 작성합니다.
     - imageRegistry={IP}:{PORT}
       - ex : imageRegistry=192.168.6.122:5000
     - templateVersion={template version}
       - ex : templateVersion=0.0.3
     - templateNamespace={template namespace}
       - ex : templateNamespace=template
     - clusterTsbVersion={cluster tsb version}
       - ex : clusterTsbVersion=0.0.3
     - clusterTsbNamespace={cluster tsb namespace}
       - ex : clusterTsbNamespace=cluster-tsb-ns
     - tsbVersion={tsb version}
       - ex : tsbVersion=0.0.3
     - tsbNamespace={tsb namespace}
       - ex : tsbNamespace=tsb-ns

## Step1. install-template
- 목적 : `template-operator 설치 진행을 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh install-template
	```

## Step2. install-cluster-tsb
- 목적 : `cluster-tsb 설치 진행을 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh install-cluster-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step3. install-tsb
- 목적 : `tsb 설치 진행을 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh install-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step4. register-cluster-tsb
- 목적 : `cluster-tsb를 servicebroker로 등록하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh register-cluster-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step5. register-tsb
- 목적 : `tsb를 servicebroker로 등록하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh register-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step6. uninstall-template
- 목적 : `template-operator를 삭제하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh uninstall-template
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step7. uninstall-cluster-tsb
- 목적 : `cluster-tsb를 삭제하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh uninstall-cluster-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step8. uninstall-tsb
- 목적 : `tsb를 삭제하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh uninstall-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step9. unregister-cluster-tsb
- 목적 : `cluster-tsb를 servicebroker해제 하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh unregister-cluster-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.

## Step10. unregister-tsb
- 목적 : `tsb를 servicebroker해제 하기 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh unregister-tsb
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.