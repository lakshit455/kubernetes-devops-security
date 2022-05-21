pipeline {
  agent any

  stages {
    stage('Build Artifact - Maven') {
      steps {
        sh "mvn clean package -DskipTests=true"
        archive 'target/*.jar'
      }
    }

    stage('Unit Tests - JUnit and Jacoco') {
      steps {
        sh "mvn test"
      }
    }
    stage('SonarQube - SAST') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh "mvn sonar:sonar \
                        -Dsonar.projectKey=hrtvb \
                        -Dsonar.host.url=http://20.58.188.143:9000 \
                        -Dsonar.login=c363187354366b4a8bd97f0cd9cdadce33ccc576"
        }
        timeout(time: 2, unit: 'MINUTES') {
          script {
            waitForQualityGate abortPipeline: true
          }
        }
      }
    }
    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker", url: ""]) {
          sh 'printenv'
          sh 'docker build -t lakshit45/dontgiveup:123 .'
          sh 'docker push lakshit45/dontgiveup:123 '
         }
       }
    }
    stage('Vulnerability Scan - Docker ') {
      steps {
        sh "mvn dependency-check:check"
      }
    }

    stage('Kubernetes Deployment - DEV') {
      steps {
        withKubeConfig([credentialsId: 'kubeconfig']) {
         sh "kubectl apply -f k8s_deployment_service.yaml"
        }
      }
    }
  } 
   post {
     always {
       junit 'target/surefire-reports/*.xml'
       jacoco execPattern: 'target/jacoco.exec'
       dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
       }
    }
}
