pipeline {
    agent any

    environment {
        IMAGE_NAME = "santhosh255/wildfly-app:${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/santhoshannadurai6256-dotcom/wildfly-cicd-project.git'
            }
        }

        stage('Build WAR') {
            steps {
                dir('app/sample-java-app') {
                    sh 'mvn clean package'
                }
            }
        }

        stage('SonarQube Scan') {
            steps {
                dir('app/sample-java-app') {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar'
                    }
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
                sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/deploy.yml'
            }
        }
    }

    post {
        failure {
            sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/rollback.yml'
        }
    }
}
