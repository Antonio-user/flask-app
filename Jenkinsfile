pipeline {
    agent any

    environment {
        REGISTRY = "localhost:4000"
        IMAGE_NAME = "flask_hello"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Antonio-user/flask-app.git'
            }
        }

        stage('Build Docker image') {
            steps {
                sh 'docker build -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f flask_app || true
                    docker run -d --name flask_app -p 5000:5000 $REGISTRY/$IMAGE_NAME:latest
                '''
            }
        }
    }
}

