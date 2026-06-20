# Prometheus + Grafana Terraform Project

## Commands

terraform init
terraform validate
terraform plan
terraform apply -auto-approve

After deployment:

SSH into EC2 and install:
- Node Exporter
- Prometheus
- Grafana

Ports:
- 22 SSH
- 3000 Grafana
- 9090 Prometheus
- 9100 Node Exporter
