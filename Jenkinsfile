pipeline {
    agent any

    environment {
        REGISTRY   = "localhost:4000"
        IMAGE_NAME = "flask_hello"
        K8S_DIR    = "k8s"
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

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    # Charger l'image dans Minikube (important pour localhost:4000)
                    minikube image load $REGISTRY/$IMAGE_NAME:latest

                    # Appliquer les manifests Kubernetes
                    kubectl apply -f $K8S_DIR/deployment.yaml
                    kubectl apply -f $K8S_DIR/service.yaml

                    # Vérifier que les pods tournent
                    kubectl rollout status deployment/flask-app
                '''
            }
        }
    }
}

