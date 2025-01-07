module "storage_dev" {
  source                      = "modules/storage"
  project_id                  = "test-interno-trendit"
  name                        = "mike-dev-2024"
  folder_name                 = "dev/data1/"
  location                    = "us-west1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
module "storage_test" {
  source                      = "modules/storage"
  project_id                  = "test-interno-trendit"
  name                        = "mike-test-2024"
  folder_name                 = "test/data1/"
  location                    = "us-west1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
