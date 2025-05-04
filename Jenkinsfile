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

        stage('Branch Identify') {
            steps {
                script {
                    def branchName = env.GIT_BRANCH?.replaceFirst(/^origin\//, '') ?: sh(script: "git rev-parse --abbrev-ref HEAD", returnStdout: true).trim()
                    env.TF_ENVIRONMENT = branchName
                    echo "🔀 Branch ${env.TF_ENVIRONMENT} selected"
                }
            }
        }

        stage('Deploy Terraform Docker Image') {
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
                dir("terraform/${env.TF_ENVIRONMENT}") {
                    sh '''
                        terraform init                       
                        terraform plan -out=tfplan
                    '''
                    //terraform apply -auto-approve tfplan
                }
            }
        }

        stage('Wating for approval') {
            when {
                expression {
                    return env.TF_ENVIRONMENT != 'test-cicd'
                }
            }
            steps {
                input message: "¿Aprobar aplicación de cambios en ${env.TF_ENVIRONMENT}?", ok: "Si", cancel: "No"
            }
        }

        stage('Apply') {
            steps {
                script {
                    echo "✅ Terraform Apply in ${env.TF_ENVIRONMENT}"
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
