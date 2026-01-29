
pipeline {
  agent any

  environment {
    IMAGE_NAME = "yourdockerhubusername/wildfly-app:${BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        git 'https://github.com/yourusername/wildfly-cicd-project.git'
      }
    }

    stage('Build WAR') {
      steps {
        sh 'mvn clean package'
      }
    }

    stage('SonarQube Scan') {
      steps {
        withSonarQubeEnv('SonarQube') {
          sh 'mvn sonar:sonar'
        }
      }
    }

    stage('Docker Build') {
      steps {
        sh 'docker build -t $IMAGE_NAME .'
      }
    }

    stage('Docker Push') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh 'docker login -u $USER -p $PASS'
          sh 'docker push $IMAGE_NAME'
        }
      }
    }

    stage('Deploy using Ansible') {
      steps {
        sh 'ansible-playbook ansible/deploy.yml'
      }
    }
  }

  post {
    failure {
      sh 'ansible-playbook ansible/rollback.yml'
    }
  }
}
