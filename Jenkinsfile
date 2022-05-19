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
      post {
        always {
          junit 'target/surefire-reports/*.xml'
          jacoco execPattern: 'target/jacoco.exec'
        }
      }
    }
    stage('Docker Build and Push') {
      steps {
        withDockerRegistry([credentialsId: "docker", url: ""]) {
          sh 'printenv'
          sh 'docker build -t lakshit45/dontgiveup:12 .'
          sh 'docker push lakshit45/dontgiveup:12'
         }
       }
    }
     stage('SonarQube - SAST') {
      steps {
        sh "mvn sonar:sonar   -Dsonar.projectKey=project1  -Dsonar.host.url=http://192.168.1.64:9000  -Dsonar.login=2aa6dc441b1117e9b6393490aaa08102f8fa721a "
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
}
