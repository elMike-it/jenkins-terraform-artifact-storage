module "storage_dev" {
  source                      = "../modules/storage"
  project_id                  = "test-interno-trendit"
  name                        = "mike-qas-2025-test12"
  folder_name                 = "qas/data1/"
  location                    = "us-west1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
module "storage_test" {
  source                      = "../modules/storage"
  project_id                  = "test-interno-trendit"
  name                        = "mike-qas2-2025-test12"
  folder_name                 = "qas2/data1/"
  location                    = "us-west1"
  force_destroy               = true
  uniform_bucket_level_access = true
}
