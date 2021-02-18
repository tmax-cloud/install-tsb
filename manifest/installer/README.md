# tsb installer 사용법

## Prerequisites
  - 해당 installer는 폐쇄망 기준 가이드입니다.
  - image registry에 이미지를 push 합니다. (Prerequisites 참고)
    - https://github.com/tmax-cloud/install-tsb/tree/tsb-4.1

## Step0. tsb.config 설정
- 목적 : `tsb 설치 진행을 위한 tsb config 설정`
- 순서 : 
  - 환경에 맞는 config 내용을 작성합니다.
     - imageRegistry={IP}:{PORT}
       - ex : imageRegistry=192.168.6.122:5000
     - tsbVersion={tsb version}
       - ex : tsbVersion=4.0.0.6
     - tsbNamespace={tsb namespace}
       - ex : tsbNamespace=tsb-ns

## Step1. install-tsb
- 목적 : `tsb 설치 진행을 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh install
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.
    - tsb를 servicebroker로 등록하고자 하는 경우 아래의 커맨드를 추가로 실행 합니다. 
    ```bash
    sudo ./install-tsb.sh register
    ```

## Step2. uninstall-tsb
- 목적 : `tsb 삭제를 위한 shell script 실행`
- 순서 : 
	```bash
    sudo ./install-tsb.sh uninstall
	```
- 비고 :
    - tsb.config, install-tsb.sh파일과 yaml 디렉토리는 같은 디렉토리 내에에 있어야 합니다.