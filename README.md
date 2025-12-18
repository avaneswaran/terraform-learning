# Terraform Learning Lab

Personal lab environment for learning Terraform with Kubernetes and HashiCorp Vault.

## Infrastructure

- Kubernetes cluster built from scratch using "Kubernetes the Hard Way"
- 4 VirtualBox VMs: jumpbox, server (control plane), node-0, node-1
- Manually configured etcd, kube-apiserver, kubelet, containerd, CNI

## State Management

All Terraform state is stored remotely in AWS S3 with DynamoDB locking:

| Component | State Key |
|-----------|-----------|
| S3 Bucket | `terraform-state-avaneswaran` |
| DynamoDB Table | `terraform-locks` |
| Region | `us-east-1` |

Features:
- Encryption at rest enabled
- Versioning enabled
- Public access blocked
- State locking prevents concurrent modifications

## Projects

| Project | Description | State Path |
|---------|-------------|------------|
| k8s-basics | Kubernetes namespaces, deployments, services | `k8s-basics/terraform.tfstate` |
| modules/k8s-app | Reusable module for K8s apps | (used by other projects) |
| vault-deploy | HashiCorp Vault on Kubernetes | `vault-deploy/terraform.tfstate` |
| vault-config | Vault secrets engines, policies, AppRole | `vault-config/terraform.tfstate` |
| postgres | PostgreSQL with Vault dynamic credentials | `postgres/terraform.tfstate` |
| consul | HashiCorp Consul in dev mode | `consul/terraform.tfstate` |
| monitoring | Prometheus, Grafana, node-exporter | `monitoring/terraform.tfstate` |

## Concepts Covered

- Providers and resources
- Variables and outputs
- Modules
- Data sources
- State management (local and S3 backend)
- Import existing resources
- Replace/rotate credentials
- Dynamic database credentials with Vault

## Quick Access
```bash
# Vault UI
kubectl port-forward -n vault svc/vault 8200:8200 --address 0.0.0.0 &

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

## Related

- [terraform-azure](https://github.com/avaneswaran/terraform-azure) - Azure infrastructure with Vault-managed secrets
