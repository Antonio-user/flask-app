pipeline {
    agent any

    environment {
        REGISTRY = "localhost:4000"
        IMAGE_NAME = "flask_hello"
        DEPLOYMENT_NAME = "flask-app"
        K8S_DIR = "k8s"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Antonio-user/flask-app.git'
            }
        }

        stage('Build Docker image') {
            steps {
                sh 'docker-internet build --network host -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh 'docker-internet push $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Load image into Minikube') {
            steps {
                sh 'minikube image load $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f $K8S_DIR/'
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl get pods'
                sh 'kubectl get svc'
            }
        }
    }
}

