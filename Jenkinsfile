pipeline {
    agent any

    environment {
        IMAGE_NAME = "flask_hello"
        K8S_DIR    = "k8s"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Antonio-user/flask-app.git'
            }
        }

        stage('Build Docker image in Minikube') {
            steps {
                // On pointe Docker sur Minikube pour que l'image soit directement disponible
                sh 'eval $(minikube -p minikube docker-env)'

                // Build l'image
                sh 'docker build --network host -t $IMAGE_NAME:latest .'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f $K8S_DIR/deployment.yaml
                    kubectl apply -f $K8S_DIR/service.yaml

                    kubectl rollout status deployment/flask-app
                '''
            }
        }
    }
}

