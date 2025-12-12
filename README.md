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

### consul
Deploys HashiCorp Consul in dev mode for service discovery and configuration.

### monitoring
Deploys Prometheus and Grafana for cluster monitoring and visualization.

## Concepts Covered

- Providers and resources
- Variables and outputs
- Modules
- Data sources
- State management
- Import existing resources
- Replace/rotate credentials
- Dynamic database credentials with Vault

## Quick Access
```bash
# Vault UI
kubectl port-forward -n vault svc/vault 8200:8200 &

# Consul UI
kubectl port-forward -n consul svc/consul 8500:8500 &

# Grafana UI
kubectl port-forward -n monitoring svc/grafana 3000:3000 &

# Generate dynamic PostgreSQL credentials
export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="root"
vault read database/creds/app-role
```

## Credentials

| Service | Username | Password |
|---------|----------|----------|
| Vault | root token | root |
| PostgreSQL | admin | rootpassword |
| Grafana | admin | admin |
