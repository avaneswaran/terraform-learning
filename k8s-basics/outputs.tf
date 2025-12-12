output "nginx_dev_ip" {
  value = module.nginx_dev.cluster_ip
}

output "nginx_staging_ip" {
  value = module.nginx_staging.cluster_ip
}

output "httpd_dev_ip" {
  value = module.httpd_dev.cluster_ip
}
