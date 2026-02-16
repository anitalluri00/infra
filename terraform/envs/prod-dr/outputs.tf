output "dr_vpc_id" {
  value = module.network.vpc_id
}

output "dr_cluster_name" {
  value = module.eks.cluster_name
}

output "dr_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
