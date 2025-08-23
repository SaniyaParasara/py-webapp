// // // 

// // pipeline {
// //     agent any

// //     options {
// //         skipDefaultCheckout()
// //         timestamps()
// //     }

// //     parameters {
// //         string(name: 'PORT', defaultValue: '9002', description: 'Port to run the website on')
// //     }

// //     environment {
// //         DOCKER_IMAGE = 'restaurant-website'
// //         DOCKER_TAG = "${env.BUILD_NUMBER}"   // unique tag per build
// //         CONTAINER_NAME = 'restaurant-website-container'
// //     }

// //     stages {
// //         stage('Prepare Workspace') {
// //             steps {
// //                 echo '🧹 Cleaning workspace before build...'
// //                 cleanWs()
// //             }
// //         }

// //         stage('Checkout') {
// //             steps {
// //                 echo '📥 Checking out code from Git repository...'
// //                 checkout scm
// //             }
// //         }

// //         stage('Build Docker Image') {
// //             steps {
// //                 echo '🐳 Building Docker image...'
// //                 script {
// //                     docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
// //                 }
// //             }
// //         }

// //         stage('Stop Previous Container') {
// //             steps {
// //                 echo '🛑 Stopping previous container if running...'
// //                 script {
// //                     sh "docker stop ${CONTAINER_NAME} || true"
// //                     sh "docker rm ${CONTAINER_NAME} || true"
// //                 }
// //             }
// //         }

// //         stage('Deploy Container') {
// //             steps {
// //                 echo '🚀 Deploying new container...'
// //                 script {
// //                     sh "docker run -d --name ${CONTAINER_NAME} -p ${params.PORT}:80 ${DOCKER_IMAGE}:${DOCKER_TAG}"
// //                 }
// //             }
// //         }

// //         stage('Health Check') {
// //             steps {
// //                 echo '🩺 Performing health check...'
// //                 script {
// //                     sleep(10) // wait for container to boot
// //                     def response = sh(
// //                         script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${params.PORT}",
// //                         returnStdout: true
// //                     ).trim()

// //                     if (response == "200") {
// //                         echo "✅ Website is up and returning 200 OK"
// //                     } else {
// //                         error "❌ Health check failed! Got HTTP ${response}"
// //                     }
// //                 }
// //             }
// //         }

// //         // Optional: Push to Docker Hub if credentials are set
// //         stage('Push to Docker Hub') {
// //             when {
// //                 expression { return env.DOCKERHUB_CREDENTIALS != null }
// //             }
// //             steps {
// //                 echo '📤 Pushing image to Docker Hub...'
// //                 script {
// //                     docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials-id') {
// //                         docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push()
// //                         docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").push("latest")
// //                     }
// //                 }
// //             }
// //         }
// //     }

// //     post {
// //         always {
// //             echo '🏁 Pipeline completed!'
// //         }
// //         success {
// //             echo "🎉 Deployment successful!"
// //             echo "🌐 Access URL: http://localhost:${params.PORT}"
// //         }
// //         failure {
// //             echo '❌ Deployment failed!'
// //             script {
// //                 sh "docker logs ${CONTAINER_NAME} || true"
// //             }
// //         }
// //         cleanup {
// //             echo '🧹 Cleaning up workspace...'
// //             cleanWs()
// //         }
// //     }
// // }

// pipeline {
//     agent any

//     options {
//         skipDefaultCheckout()
//         timestamps()
//         ansiColor('xterm')
//     }

//     parameters {
//         string(name: 'PROXY_PORT', defaultValue: '9002', description: 'Host port where nginx-proxy will be exposed (host:PROXY_PORT:80)')
//         choice(name: 'ENV', choices: ['dev','production'], description: 'Choose environment')
//     }

//     environment {
//         COMPOSE_FILE = "docker-compose.yml"
//     }

//     stages {
//         stage('Prepare') {
//             steps {
//                 echo "🧹 Cleaning workspace"
//                 cleanWs()
//             }
//         }

//         stage('Checkout') {
//             steps {
//                 echo "📥 Checkout code"
//                 checkout scm
//             }
//         }

//         stage('Build & Deploy (docker-compose)') {
//             steps {
//                 echo "🐳 Build and start containers with docker-compose"
//                 script {
//                     // Ensure docker-compose is present on Jenkins agent or use docker-in-docker agent
//                     sh "docker-compose -f ${COMPOSE_FILE} up -d --build --remove-orphans"
//                 }
//             }
//         }

//         stage('Health Check') {
//             steps {
//                 echo "🔎 Performing health check against proxy on port ${params.PROXY_PORT}"
//                 script {
//                     // wait a bit for containers to be up
//                     sleep 8
//                     def code = sh (
//                         script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${params.PROXY_PORT}/ || true",
//                         returnStdout: true
//                     ).trim()

//                     if (code == '200') {
//                         echo "✅ Health check passed (HTTP 200)"
//                     } else {
//                         error "❌ Health check failed. HTTP code: ${code}"
//                     }
//                 }
//             }
//         }
//     }

//     post {
//         success {
//             echo "🎉 Deployment succeeded — app available at http://<server-ip>:${params.PROXY_PORT}"
//         }
//         failure {
//             echo "❌ Deployment failed — gathering logs..."
//             script {
//                 sh "docker-compose -f ${COMPOSE_FILE} logs --no-color || true"
//             }
//         }
//         always {
//             echo "🧹 Pipeline finished"
//         }
//     }
// }


pipeline {
    agent any

    options {
        skipDefaultCheckout()
        timestamps()
    }

    parameters {
        string(name: 'PROXY_PORT', defaultValue: '9002', description: 'Host port where nginx-proxy will be exposed (host:PROXY_PORT:80)')
        choice(name: 'ENV', choices: ['dev','production'], description: 'Choose environment')
    }

    environment {
        COMPOSE_FILE = "docker-compose.yml"
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

        stage('Build & Deploy (docker-compose)') {
            steps {
                echo "🐳 Build and start containers with docker-compose"
                script {
                    // Try multiple approaches to run docker-compose
                    sh """
                        # Check if docker-compose is available
                        if command -v docker-compose &> /dev/null; then
                            echo "Using docker-compose command"
                            docker-compose -f ${COMPOSE_FILE} up -d --build --remove-orphans
                        elif docker compose version &> /dev/null; then
                            echo "Using docker compose command"
                            docker compose -f ${COMPOSE_FILE} up -d --build --remove-orphans
                        else
                            echo "Docker Compose not found, trying to install it..."
                            # Try to install docker-compose if not available
                            if command -v curl &> /dev/null; then
                                curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
                                chmod +x /usr/local/bin/docker-compose
                                docker-compose -f ${COMPOSE_FILE} up -d --build --remove-orphans
                            else
                                echo "❌ Cannot install docker-compose - curl not available"
                                exit 1
                            fi
                        fi
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                echo "🔎 Performing health check against proxy on port ${params.PROXY_PORT}"
                script {
                    sleep 8
                    def code = sh (
                        script: "curl -s -o /dev/null -w '%{http_code}' http://localhost:${params.PROXY_PORT}/ || true",
                        returnStdout: true
                    ).trim()

                    if (code == '200') {
                        echo "✅ Health check passed (HTTP 200)"
                    } else {
                        error "❌ Health check failed. HTTP code: ${code}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "🎉 Deployment succeeded — app available at http://<server-ip>:${params.PROXY_PORT}"
        }
        failure {
            echo "❌ Deployment failed — gathering logs..."
            script {
                sh """
                    if command -v docker-compose &> /dev/null; then
                        docker-compose -f ${COMPOSE_FILE} logs --no-color || true
                    elif docker compose version &> /dev/null; then
                        docker compose -f ${COMPOSE_FILE} logs --no-color || true
                    else
                        echo "Cannot gather logs - Docker Compose not available"
                    fi
                """
            }
        }
        always {
            echo "🧹 Pipeline finished"
        }
    }
}
