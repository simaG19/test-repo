pipeline {
  agent any
  environment {
    IMAGE = "simonbekele/my-test:${env.BUILD_NUMBER}"
    LATEST = "simonbekele/my-test:latest"
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build image') {
      steps {
        script {
          // Force unix socket and clear TLS envs for the docker CLI used in this shell
          sh '''
            echo "Using docker via unix socket..."
            export DOCKER_HOST=unix:///var/run/docker.sock
            unset DOCKER_TLS_VERIFY
            unset DOCKER_CERT_PATH
            docker version
            docker build -t ${IMAGE} .
            docker tag ${IMAGE} ${LATEST}
          '''
        }
      }
    }

    stage('Push image') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          script {
            sh '''
              export DOCKER_HOST=unix:///var/run/docker.sock
              unset DOCKER_TLS_VERIFY
              unset DOCKER_CERT_PATH
              echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
              docker push ${IMAGE}
              docker push ${LATEST}
            '''
          }
        }
      }
    }
  }

  post {
    always {
      echo "Build ${env.BUILD_NUMBER} finished. Check logs above for details."
    }
  }
}
