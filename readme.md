### 카카오페이증권 DevOps 과제

### 과제 내용

웹 어플리케이션 [spring-petclinic-data-jdbc](https://github.com/spring-petclinic/spring-petclinic-data-jdbc)을 Kubernetes 환경에서 실행하고자 합니다.

* 다음의 요구사항에 부합하도록 빌드스크립트, 어플리케이션 코드 등을 작성하십시오.
* Kubernetes에 배포하기 위한 manifest 파일을 작성하십시오.


### 요구사항 및 답변
* gradle을 사용하여 어플리케이션과 도커이미지를 빌드한다.
  * -> build.gradle
* 어플리케이션의 log는 host의 /logs 디렉토리에 적재되도록 한다.
  * -> logback-spring.xml, deployment.yaml
* 정상 동작 여부를 반환하는 api를 구현하며, 10초에 한번 체크하도록 한다.
  * 3번 연속 체크에 실패하면 어플리케이션은 restart 된다.
    * -> springboot actuator health endpoint를 활용하여 살아있거나 트래픽을 받을 준비를 확인한다. 또한 커스텀 로직으로 확인을 하려하면 pingController 따위를 만들어서 probe로 활용할 수도 있습니다.
    * -> spec.template.spec.containers.livenessProbe.periodSeconds(k8s): 10
    * -> spec.template.spec.containers.livenessProbe.failureThreshold(k8s): 3
* 종료 시 30초 이내에 프로세스가 종료되지 않으면 SIGKILL로 강제 종료 시킨다.
  * -> terminationGracePeriodSeconds(k8s, 30s) >= preStop(k8s, 10s) + timeout-per-shutdown-phase(spring-boot, 20s)
* 배포 시와 scale in/out 시에는 유실되는 트래픽이 없어야한다.
  * -> scaleIn: graceful shutdown
  * -> scaleOut: readinessProbe
* 어플리케이션 프로세스는 root 계정이 아닌 uid:1000으로 실행한다.
  * -> build.gradle(`jib`), deployment.yaml(`spec.template.spec.SecurityContext.runAsUser`)
* DB도 kubernetes에서 실행하며 재 실행 시에도 변경된 데이터는 유실되지 않도록 설정한다.
  * -> PersistentVolumeClaim.yaml
* 어플리케이션과 DB는 cluster domain으로 통신한다.
  * -> application-prod.yaml (`jdbc:mysql://mysql.default:3306/petclinic`)
* nginx-ingress-controller 통해 어플리케이션에 접속이 가능하다. 
  * -> ingress.yaml(`ingressclass: nginx`)
* namespace는 default를 사용한다.
  * -> kustomization.yaml(`namespace`)
* README.md 파일에 실행 방법을 기술한다.
  * -> manifests에 있는 k8s yaml 파일들을 `kubectl apply(delete) -k {app}/overlays` 로 실행하면 됩니다.
  * -> 또는 로컬에서 확인시 docker-compose.yml를 실행합니다 `docker-compose up -d`.
  * -> nginx로 들어오는 엔드포인트는 사내망 구간이라 접속 불가능하십니다.

### 제출방법
* 해당 README.md 파일에 내용을 지우시고 이 repository에 과제를 작성해 주세요


---
해당 프로젝트를 포크한 이후에 요구사항을 맞춰 구현합니다.

### 환경 정보
* k8s: AWS EKS v1.24
* nginx-ingress-controller, ebs-csi-driver는 요구 사항을 만족시키기에 필요하나 과제 밖의 범위이라 생각하여 readme에 포함하진 않았습니다.  
다만 준비되어 있는 클라우드 환경입니다.

```
Kustomize Version: v4.5.7
Server Version: version.Info{Major:"1", Minor:"24+", GitVersion:"v1.24.13-eks-0a21954", GitCommit:"6305d65c340554ad8b4d7a5f21391c9fa34932cb", GitTreeState:"clean", BuildDate:"2023-04-15T00:33:45Z", GoVersion:"go1.19.8", Compiler:"gc", Platform:"linux/amd64"}
```

* [jmeter result test](images/jmeter.png)
* [local 환경 실행시](images/docker-compose.png)
