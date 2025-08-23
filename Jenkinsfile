pipeline {
    agent any

    options {
        skipDefaultCheckout()
        timestamps()
    }

    environment {
        PORT = '4000'
        IMAGE_NAME = 'restaurant-website'
        CONTAINER_NAME = 'restaurant-container'
    }

    stages {
        stage('Prepare') {
            steps {
                echo "🧹 Cleaning workspace"
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                echo "📥 Checkout code"
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image"
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Stop Previous Container') {
            steps {
                echo "🛑 Stopping previous container"
                script {
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo "🚀 Deploying to production"
                script {
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${PORT}:80 ${IMAGE_NAME}"
                }
            }
        }

        stage('Health Check') {
            steps {
                echo "🔎 Health check"
                script {
                    sleep 5
                    def code = sh (
                        script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${PORT}/ || true",
                        returnStdout: true
                    ).trim()

                   
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment succeeded!"
            echo "🌐 Website available at: http://localhost:${PORT}"
        }
        failure {
            echo "❌ Deployment failed!"
            script {
                sh "docker logs ${CONTAINER_NAME} || true"
            }
        }
        always {
            echo "🧹 Pipeline finished"
        }
    }
}
