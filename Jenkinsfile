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
                // Option A : build dans Docker normal puis push au registre local
                sh 'docker-internet build --network host -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh 'docker-internet push $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Setup Minikube') {
            steps {
                // Démarrer Minikube si ce n'est pas déjà fait
                sh 'minikube start --driver=docker || echo "Minikube already started"'
                sh 'kubectl get nodes'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    # Charger l'image dans Minikube
                    minikube image load $REGISTRY/$IMAGE_NAME:latest

                    # Appliquer les manifests Kubernetes
                    kubectl apply -f $K8S_DIR/deployment.yaml
                    kubectl apply -f $K8S_DIR/service.yaml

                    # Vérifier que le déploiement est prêt
                    kubectl rollout status deployment/flask-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                // Vérifier que les pods tournent correctement
                sh 'kubectl get pods -o wide'
                sh 'kubectl get svc -o wide'
            }
        }
    }
}

