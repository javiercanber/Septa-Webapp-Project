output "repository_url" {
  value = module.septa_ecr.septa_ecr_repo.repository_url
}

output "septa-repository-name" {
  value = module.septa_ecr.septa_ecr_repo.name
}

output "region" {
  value = var.region
}