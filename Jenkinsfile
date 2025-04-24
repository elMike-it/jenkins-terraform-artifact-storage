pipeline {
    agent any

    environment {
        PROJECT_ID = 'test-interno-trendit'
        SERVICE_NAME = 'mike-cloud-run-service-tf'
        REGION = 'us-central1'
        IMAGE_NAME = "gcr.io/${PROJECT_ID}/${SERVICE_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Leer Entorno desde Archivo') {
            steps {
                script {
                    fileContents = readFile 'env.sh'
                    echo "Ejecutando Terraform en: ${fileContents}"
                }
            }
        }

        stage('Terraform with Docker') {
            agent {
                docker {
                    image 'hashicorp/terraform:latest'
                    args '--entrypoint=""'
                }
            }

            environment {
                GOOGLE_APPLICATION_CREDENTIALS = "${WORKSPACE}/gcp-key.json"
            }

            steps {
                withCredentials([file(credentialsId: 'gcp-terraform-service-account-key', variable: 'GCP_CRED_FILE')]) {
                    sh 'cp $GCP_CRED_FILE $GOOGLE_APPLICATION_CREDENTIALS'
                }
                dir("terraform/${fileContents}") {
                    sh '''
                        terraform init
                        terraform plan -out=tfplan
                    '''
                    //terraform apply -auto-approve tfplan
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
