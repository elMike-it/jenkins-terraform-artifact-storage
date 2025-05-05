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

        stage('Pull Request?') {
            steps {
                script {
                    env.IS_PR = env.CHANGE_ID ? 'true' : 'false'
                    echo "🔍 Pull Request?: ${env.IS_PR}"
                }
            }
        }

        stage('Wating for approval') {
            when {
                allOf {
                    expression {
                        return env.TF_ENVIRONMENT != 'test-cicd'
                        expression { return env.IS_PR != 'true' } // Si NO es PR

                    }
                }
            }
            steps {
                input message: "¿Aprobar aplicación de cambios en ${env.TF_ENVIRONMENT}?"
            }
        }

        stage('Apply') {
            when {
                allOf {
                    expression {
                        return env.TF_ENVIRONMENT != 'test-cicd'
                        expression { return env.IS_PR != 'true' } // Si NO es PR
                    }
                }
            }
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
