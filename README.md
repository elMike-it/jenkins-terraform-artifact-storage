# Pipeline Jenkins to deploy Storage and Artifact Repository by Terraform

## 0. Planing Jenkins pipeline

## 1. SA: Create SA with the necessary access

- roles/artifactregistry.admin
- roles/storage.admin
- Storage Object Admin

## 2. Create Jenkins object: Pipeline

- SCM (Source code management)
- Git (http github url)
- Branch
- Jenkinsfile path

## 3. Create Secret File

- Secret file: key.json

## 4. Installing plugins

- Terraform
- Google Cloud SDK
