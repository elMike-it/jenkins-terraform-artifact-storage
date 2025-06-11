pipeline {
    agent any

    options {
        ansiColor('xterm')  // From ansiColor Plugin 
    }

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
                    env.SELECTED_BRANCH = branchName
                    echo "🔀 Branch ${env.SELECTED_BRANCH} selected"
                }
            }
        }

        stage('Deploy Terraform Docker Image and PLAN') {
            when {
                allOf {
                    expression {
                        return ['pipeline-pro', 'pipeline-dev', 'pipeline-qas'].contains(env.SELECTED_BRANCH)
                    }
                }
            }
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
                dir("terraform/${env.SELECTED_BRANCH}") {
                    sh '''
                        terraform init                       
                        terraform plan -out=tfplan
                        terraform apply
                    '''
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
