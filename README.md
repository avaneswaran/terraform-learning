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
Deploys HashiCorp Vault on Kubernetes in dev mode.

### vault-config
Configures Vault using Terraform:
- KV v2 secrets engine
- AppRole authentication
- Policies
- Database secrets engine with dynamic PostgreSQL credentials

### postgres
Deploys PostgreSQL on Kubernetes, integrated with Vault for dynamic credential generation.

## Concepts Covered

- Providers and resources
- Variables and outputs
- Modules
- Data sources
- State management
- Import existing resources
- Replace/rotate credentials
- Dynamic database credentials with Vault

## Dynamic Database Credentials Demo
```bash
# Generate temporary PostgreSQL credentials
vault read database/creds/app-role
```

Vault creates a real user in PostgreSQL with a TTL. When the lease expires, Vault automatically revokes the credentials.
