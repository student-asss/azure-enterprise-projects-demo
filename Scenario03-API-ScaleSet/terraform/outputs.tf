output "vmss_id" {
  value = module.vmss.vmss_id
}

output "ilb_ip" {
  value = module.loadbalancer.ilb_ip
}
