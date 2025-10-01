pipeline {
    agent any

    environment {
        REGISTRY   = "localhost:4000"
        IMAGE_NAME = "flask_hello"
        K8S_DIR    = "k8s"
        KUBECONFIG = "/home/antonio/.kube/config" // Chemin vers kubeconfig de ton utilisateur
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Antonio-user/flask-app.git'
            }
        }

        stage('Build Docker image') {
            steps {
                // Construire l'image Docker
                sh 'docker build --network host -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                // Pousser l'image dans le registre local (si utilisé)
                sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Load image into Minikube') {
            steps {
                // Charger l'image directement dans Minikube
                sh 'minikube image load $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    # Appliquer les manifests Kubernetes
                    kubectl apply -f $K8S_DIR/deployment.yaml
                    kubectl apply -f $K8S_DIR/service.yaml

                    # Vérifier que les pods sont déployés correctement
                    kubectl rollout status deployment/flask-app
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                // Vérifier que les pods tournent
                sh 'kubectl get pods -n default'
                sh 'kubectl get svc -n default'
            }
        }
    }
}

