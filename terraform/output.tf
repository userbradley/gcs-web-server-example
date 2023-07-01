output "iap_client_secret" {
  value     = module.gcs-web-server.iap_client_secret
  sensitive = true
}

output "iap_client_id" {
  value = module.gcs-web-server.iap_client_id
}

output "ip_address" {
  value = module.gcs-web-server.ip_address
}
