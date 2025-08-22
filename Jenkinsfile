pipeline {
    agent any

    tools {
        nodejs "NodeJS"
    }

    environment {
        IMAGE_NAME = 'jeicho123/shop-product-service'
    }

    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test -- --passWithNoTests'
            }
        }
        stage('Security Scan') {
            steps {
                sh 'npm audit --audit-level=high || true'
            }
        }
        stage('Build image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:latest -t ${IMAGE_NAME}:${GIT_COMMIT} ."
            }
        }
        stage('Push to dockerhub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        docker push ${IMAGE_NAME}:latest
                        docker push ${IMAGE_NAME}:${GIT_COMMIT}
                        docker logout
                    '''
                }
            }
        }

        stage('Deploy to Dev') {
            when {
                branch 'develop'
            }
            steps {
                echo "Deploying to DEV environment..."
                // kubectl apply -f k8s/dev.yaml
            }
        }

        stage('Deploy to Staging') {
            when {
                branch pattern: "release/.*", comparator: "REGEXP"
            }
            steps {
                echo "Deploying to STAGING environment..."
                // kubectl apply -f k8s/staging.yaml
            }
        }

        stage('Deploy to Prod') {
            when {
                branch 'main'
            }
            steps {
                input message: "Deploy to PROD?", ok: "Yes, deploy"
                echo "Deploying to PROD environment..."
                // kubectl apply -f k8s/prod.yaml
            }
        }
    }
}
