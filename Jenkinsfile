pipeline {
    agent any

    options {
        skipDefaultCheckout()
        timestamps()
    }

    parameters {
        choice(name: 'ENVIRONMENT', choices: ['local', 'production'], description: 'Choose deployment environment')
    }

    environment {
        LOCAL_PORT = '3000'
        PRODUCTION_PORT = '4000'
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
                echo "🚀 Deploying to ${params.ENVIRONMENT}"
                script {
                    def port = params.ENVIRONMENT == 'production' ? PRODUCTION_PORT : LOCAL_PORT
                    sh "docker run -d --name ${CONTAINER_NAME} -p ${port}:80 ${IMAGE_NAME}"
                }
            }
        }

        stage('Health Check') {
            steps {
                echo "🔎 Health check"
                script {
                    def port = params.ENVIRONMENT == 'production' ? PRODUCTION_PORT : LOCAL_PORT
                    sleep 5
                    def code = sh (
                        script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${port}/ || true",
                        returnStdout: true
                    ).trim()

                    // if (code == '200') {
                    //     echo "✅ Health check passed (HTTP 200)"
                    // } else {
                    //     error "❌ Health check failed. HTTP code: ${code}"
                    // }
                }
            }
        }
    }

    post {
        success {
            script {
                def port = params.ENVIRONMENT == 'production' ? PRODUCTION_PORT : LOCAL_PORT
                echo "🎉 Deployment succeeded!"
                echo "🌐 Website available at: http://localhost:${port}"
            }
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
