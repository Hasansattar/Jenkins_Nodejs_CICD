pipeline {
    agent any

    environment {
        NODE_ENV = 'production'
        DOCKER_IMAGE = 'nodejs-jenkins-demo' // Local image name
    }

    stages {
        stage('Install Dependencies') {
            steps {
                echo 'Installing dependencies...'
                sh 'npm install'
            }
        }
        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                sh 'npm test'
            }
        }
        // stage('Build') {
        //     steps {
        //         echo 'Building the application...'
        //         sh 'npm run build' // Add your build command if needed
        //     }
        // }
          stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                // Build the Docker image using the Dockerfile
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        
        // stage('Deploy') {
        //     steps {
        //         echo 'Deploying the application...'
        //         // Add your deployment commands here, e.g., Docker, Kubernetes, etc.
        //         // e.g., sh 'scp -r * user@server:/path/to/app'
        //     }
        // }
        stage('Deploy with Docker') {
            steps {
                echo 'Deploying the Docker container...'
                // Stop and remove any previous running container
                sh "docker stop nodejs-jenkins-demo || true && docker rm nodejs-jenkins-demo || true"
                
                // Run the new container from the locally built Docker image
                sh "docker run -d -p 3000:3000 --name nodejs-jenkins-demo ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check the logs!'
        }
    }
}
