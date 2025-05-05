module "artifact" {
  source         = "../modules/artifact"
  location       = "us-west1"
  repository_id  = "mike-repository-qas-test9"
  description    = "example docker repository"
  format         = "DOCKER"
  immutable_tags = true
}

