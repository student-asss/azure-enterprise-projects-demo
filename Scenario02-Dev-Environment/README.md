# Scenario 02 – Secure Development Environment
## 🎯 Objective
Design and deploy a secure, cost‑efficient development environment in Azure. The environment must prevent accidental exposure to the internet, enforce governance rules, and ensure developers can work safely without generating unnecessary cloud costs.

---

## Architecture Overview
This scenario uses a Virtual Network with a dedicated subnet for development virtual machines. A Network Security Group restricts inbound traffic, and Azure Bastion is used for secure remote access without public IP addresses. Azure Policy enforces governance rules related to network security and resource restrictions.
### **Key components:**
- Virtual Network (vnet-norwayeast) with subnet (snet-norwayeast-1) 
- Network Security Group with restricted inbound rules 
- Azure Bastion for secure remote access 
- B‑series development VM (Standard B2ts v2) 
- Azure Policy assignments for governance 
- Budget alerts for cost control

---

## Azure Services Used
- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Azure Bastion
- Virtual Machine (Standard B2ts v2)
- Azure Policy
- Cost Management + Budgets

---

## Network Design
- **VNet:** 172.16.0.0/16 
- **Subnet:** 172.16.0.0/24 
- **NSG Rules:** 
    - Allow VNet inbound (Azure-managed) 
    - Allow Azure Load Balancer inbound (Azure-managed) 
    - Deny all other inbound traffic 
    - Outbound allowed (default)

This ensures the VM is isolated and only accessible through Bastion.

---

## Compute Layer
- **VM Size:** Standard B2ts v2 (low-cost B‑series) 
- **OS:** Ubuntu 24.04 
- **Public IP:** None (removed after deployment) 
- **Access Method:** Azure Bastion only

---

## Governance
# Azure Policy assignments include:
**1. Not allowed resource types** 
**Effect:** Deny 
**Purpose:** Prevents creation of Public IP resources in the development resource group. 
**Parameters Used:** 
```json``` 
{ 
    "notAllowedResourceTypes": [ 
        "Microsoft.Network/publicIPAddresses" 
    ] 
}

---

## Cost Management
- Budget created for the subscription or resource group
- Alerts configured at 50% and 80% thresholds
- VM chosen specifically for low cost

---

## Security Considerations
- No public IPs
- Bastion-only access
- NSG blocks all inbound traffic
- Policy prevents misconfiguration
- Segmentation through dedicated subnet

---

## Testing
- Verified VM access through Bastion
- Attempted to create a VM with a disallowed SKU (policy blocked it)
- Attempted to create a Public IP (policy blocked it)
- Checked NSG logs to confirm no inbound traffic allowed

---

## Lessons Learned
- Azure Policy is extremely effective for enforcing standards
- Bastion provides secure access without exposing VMs
- Development environments must be cost optimized
- Network isolation is essential even for non-production workloads
- Governance + security + cost control must work together

