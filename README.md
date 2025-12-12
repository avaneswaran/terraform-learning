# Terraform Learning Lab

Personal lab environment for learning Terraform with Kubernetes and HashiCorp Vault.

## Infrastructure

- Kubernetes cluster built from scratch using "Kubernetes the Hard Way"
- 4 VirtualBox VMs: jumpbox, server (control plane), node-0, node-1
- Manually configured etcd, kube-apiserver, kubelet, containerd, CNI

## Projects

### k8s-basics
Terraform managing Kubernetes resources (namespaces, deployments, services).

### modules/k8s-app
Reusable module for deploying containerized applications.

### vault-deploy
Deploys HashiCorp Vault on Kubernetes.

### vault-config
Configures Vault using Terraform:
- KV secrets engine
- AppRole authentication
- Policies

## Concepts Covered

- Providers and resources
- Variables and outputs
- Modules
- Data sources
- State management
- Import existing resources
- Replace/rotate credentials
