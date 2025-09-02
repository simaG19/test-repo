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
          // Build the image (uses Docker on the agent)
          def img = docker.build(env.IMAGE)
          // tag as latest as well
          img.tag("latest")
        }
      }
    }

    stage('Push image') {
      steps {
        // Use the credentials id you created in Jenkins
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          script {
            // Login + push using the Docker pipeline helpers
            docker.withRegistry('', 'docker-hub-creds') {
              docker.image(env.IMAGE).push()
              docker.image(env.LATEST).push()
            }
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
