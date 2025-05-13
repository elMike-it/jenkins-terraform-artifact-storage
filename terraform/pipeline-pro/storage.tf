module "storage_dev" {
  source                      = "../modules/storage"
  project_id                  = "test-interno-trendit"
  name                        = "mike-pro-2025-test12"
  folder_name                 = "pro/data1/"
  location                    = "us-west1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
module "storage_test" {
  source                      = "../modules/storage"
  project_id                  = "test-interno-trendit"
  name                        = "mike-pro2-2025-test12"
  folder_name                 = "pro2/data1/"
  location                    = "us-west1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
