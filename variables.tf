
#AKS Group ID
variable "aks-admins-group-object-id" {
  description = "Value of the Object ID created by AD for AKS Admin"
  type        = string
  default     = "ac4a098a-f17e-4d8c-8ef4-49c5e93367a4"
}

#Common Location Prefix
variable "common-location" {
  description = "Value of the Common Location"
  type        = string
  default     = "eu-west-1"
}

#Common Name Prefix
variable "common-name-prefix" {
  description = "Value of the Common Name Prefix"
  type        = string
  default     = "nielang.devopsthehardway"
}

#Container Registry Name
variable "container-registry-name" {
  description = "Value of the Name tag for the Container Registry Name"
  type        = string
  default     = "nielangweek6dockeracr"
}

#Container Registry Name
variable "container-vm-size" {
  description = "Value of the VM Size"
  type        = string
  default     = "Standard_D2_v2"
}

#Group Policy
variable "group-policy-arn" {
  description = "Value of the Group Policy ARN"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}


#Kubernetes Version
variable "kubernetes-version" {
  description = "Value of the Kubernetes version"
  type        = string
  default     = "1.23.12"
}

#Log Analytics Solution Name
variable "log-analytics-solution" {
  description = "Value of the Name tag for the Log Analytics Solution Name"
  type        = string
  default     = "ContainerInsights" #nielang-week6-container-solution"
}

#Log Analytics Workspace Name
variable "log-analytics-workspace" {
  description = "Value of the Name tag for the Log Analytics Workspace Name"
  type        = string
  default     = "nielang-week6-workspace"
}


#Resource Group Name
variable "resource-group-name" {
  description = "Value of the Name tag for the Resource Group Name"
  type        = string
  default     = "nielang-week6docker-trg"
}

#Resource Group Name for the Node
variable "resource-group-node-name" {
  description = "Value of the Name tag for the Resource Group Name for the Node"
  type        = string
  default     = "nielang-week6docker-node-rg"
}

#SSH Public Key
variable "ssh-public-key" {
  description = "Value of the SSH Public Key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrt/GYkYpuQYRxM3lgjOr3Wqx8g5nQIbrg6Mr53wZGb35+ft+PibDMqxXZ7xq7fC3YuLnnO022IPgEjkF9fP03ZmfUeLjJJvw8YcutN9DD/2cx93BpKFPNUsqEB+za1iJ16kMsCojy35c1R64O+rw20D6iP96rmDAyIc5FR03y00eyAzQ8vo7/u9+VPwpdGEI7QCokZROcj6iNVz1V/1t6G4AEufPLokdj8J0gla/dN+tvnSLRQVBTDiD4jmVGImpWFqqKaH6R9SSXmRzj0uhvJUmSiZAZCb1caPEYgPEvNITuGQFdykPoY/4Z/3B+x/ipEQbWy8yL7bDFSXZTYhVKlPVyPbUtN5QFt7QtCtg84xDAZ6GA6AnONTtMxX2jvdzB9yh1ZsteNrOZ/Jo3ecuie573syQfG23Tu6qTqak8O7ZTOLY9iPx2ego3KvTWH/Q3lIvjnlpfCQtFtSgkNxjalMBk+NwwEgZHWRREOHwJmQIKVN0gSitN1KXobrqwxNk= tamops@Synth"
}


#Virtual Network Name
variable "virtual-network-name" {
  description = "Value of the Name tag for the Virtual Network Name"
  type        = string
  default     = "nielang-virtual-network"
}

#Virtual PC Name
variable "virtual-pc-name" {
  description = "Value of the Name tag for the VPC Name"
  type        = string
  default     = "vpc"
}

#Virtual Network AKS Name
variable "vnet-subnet-aks" {
  description = "Value of the Name tag for the Virtual Network AKS Subnet Name"
  type        = string
  default     = "nielang-vnet-aks"
}

#Virtual Network Firewall Name
variable "vnet-subnet-appgwy" {
  description = "Value of the Name tag for the Virtual Network Firewall Subnet Name"
  type        = string
  default     = "nielang-vnet-firewall"
}

#Virtual Network Gateway Name
variable "vnet-subnet-gateway" {
  description = "Value of the Name tag for the Virtual Network Gateway Subnet Name"
  type        = string
  default     = "nielang-vnet-gateway"
}

#Virtual Network SQL Subnet Name
variable "vnet-subnet-sql" {
  description = "Value of the Name tag for the Virtual Network SQL Subnet Name"
  type        = string
  default     = "nielang-vnet-sql"
}

#Virtual Network WAF Subnet Name
variable "vnet-subnet-waf" {
  description = "Value of the Name tag for the Virtual Network WAF Subnet Name"
  type        = string
  default     = "nielang-vnet-waf"
}

#Virtual Network Web1 Subnet Name
variable "vnet-subnet-web1" {
  description = "Value of the Name tag for the Virtual Network Web1 Subnet Name"
  type        = string
  default     = "nielang-vnet-web1"
}

#Virtual Network Web2 Subnet Name
variable "vnet-subnet-web2" {
  description = "Value of the Name tag for the Virtual Network Web2 Subnet Name"
  type        = string
  default     = "nielang-vnet-web2"
}

