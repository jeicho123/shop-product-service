pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds() }
  environment {
    REGISTRY = "docker.io/jeicho123"
    SERVICE_NAME = "shop-product-service"
    IMAGE = "${REGISTRY}/${SERVICE_NAME}"
    DOCKERHUB_CREDENTIALS = "dockerhub-creds"
    BUILD_TAG_ONLY = "build-${BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') { steps { checkout scm } }

    stage('Docker Build & Push') {
      steps {
        script {
          docker.withRegistry("https://${env.REGISTRY}", "${DOCKERHUB_CREDENTIALS}") {
            sh """
              docker build -t ${IMAGE}:${BUILD_TAG_ONLY} .
              docker push ${IMAGE}:${BUILD_TAG_ONLY}
            """
          }
        }
      }
    }
  }
}
