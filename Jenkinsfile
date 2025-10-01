pipeline {
    agent any

    environment {
        REGISTRY   = "localhost:4000"
        IMAGE_NAME = "flask_hello"
        K8S_DIR    = "k8s"
        // On pointe Jenkins sur son kubeconfig
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Antonio-user/flask-app.git'
            }
        }

        stage('Build Docker image') {
            steps {
                sh 'docker build --network host -t $REGISTRY/$IMAGE_NAME:latest .'
            }
        }

        stage('Push to Local Registry') {
            steps {
                sh 'docker push $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Load image into Minikube') {
            steps {
                sh 'minikube image load $REGISTRY/$IMAGE_NAME:latest'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f $K8S_DIR/deployment.yaml
                    kubectl apply -f $K8S_DIR/service.yaml

                    # Vérifier que le déploiement s'est bien passé
                    kubectl rollout status deployment/flask-app
                '''
            }
        }
    }
}

