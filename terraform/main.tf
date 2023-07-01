module "gcs-web-server" {
  source          = "git@github.com:userbradley/gcs-web-server//terraform?ref=v1.0.0"
  env             = "dev"
  deployment_name = "gcs-web-server-example"
  iap_enabled     = true
  gke_project     = "gke-project"
  secret_project  = "secret-project"
  service_project = "gcs-web-server-example"
  region          = "europe-west2"
}
