module "artifact" {
  source         = "../modules/artifact"
  location       = "us-west1"
  repository_id  = "mike-repository-dev-test12"
  description    = "example docker repository"
  format         = "DOCKER"
  immutable_tags = true
}

