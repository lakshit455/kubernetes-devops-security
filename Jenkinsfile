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
          sh 'docker build -t lakshit45/dontgiveup:123 .'
          sh 'docker push lakshit45/dontgiveup:123 '
         }
       }
    }
    stage('Vulnerability Scan - Docker ') {
      steps {
        sh "mvn dependency-check:check"
      }
      post {
        always {
          dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
        }
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
