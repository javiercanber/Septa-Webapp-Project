output "repository_url" {
  value = module.septa_ecr.repository_url
}

output "septa-repository-name" {
  value = module.septa_ecr.name
}

output "region" {
  value = var.region
}