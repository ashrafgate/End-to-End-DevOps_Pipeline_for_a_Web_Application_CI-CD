pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
        AWS_ACCOUNT_ID = "605134464535"
        IMAGE_REPO_NAME = "app/mywebapp"
        IMAGE_TAG = "latest"
        REPOSITORY_URI = "605134464535.dkr.ecr.ap-south-1.amazonaws.com/app/webapp"
    }

    stages {
        stage('Logging into AWS ECR') {
            steps {
                script {
                    sh """
                    aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                    docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                    """
                }
            }
        }


        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build("${IMAGE_REPO_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage('Pushing to ECR') {
            steps {
                script {
                    sh """
                    docker tag ${IMAGE_REPO_NAME}:${IMAGE_TAG} ${REPOSITORY_URI}:${IMAGE_TAG}
                    docker push ${REPOSITORY_URI}:${IMAGE_TAG}
                    """
                }
            }
        }

        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('eks-cluster') {
                        sh "terraform init"
                        sh "terraform $action -auto-approve"
                    }
                }
            }
		}
        
        stage('K8S Deploy') {
            steps {
                script {
		    dir('kubernets') {
                    	sh "aws eks update-kubeconfig --name my-cluster --region ap-south-1"
			sh "cat /var/lib/jenkins/.kube/config"
                        sh 'kubectl apply -f deployment.yml'
						
					}
				}
			}
		}
	}
}
