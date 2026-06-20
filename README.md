# 🚀 Prometheus + Grafana Monitoring on AWS EC2 using Terraform

## 📌 Project Overview

This project demonstrates how to provision an AWS EC2 instance using Terraform and set up a complete monitoring stack with:

* Terraform
* AWS EC2
* Prometheus
* Node Exporter
* Grafana

The goal is to collect Linux server metrics, store them in Prometheus, and visualize them using Grafana dashboards.

---

## 🏗️ Architecture

```text
AWS EC2 (Amazon Linux 2023)
│
├── Prometheus (Port 9090)
│
├── Grafana (Port 3000)
│
└── Node Exporter (Port 9100)
```

---

## 📋 Prerequisites

* AWS Account
* AWS CLI Configured
* Terraform Installed
* Existing AWS Key Pair
* Security Group allowing:

  * 22 (SSH)
  * 3000 (Grafana)
  * 9090 (Prometheus)
  * 9100 (Node Exporter)

---

## ⚙️ Step 1: Configure AWS Credentials

Verify credentials:

```bash
aws sts get-caller-identity
```

Expected Output:

```json
{
  "Account": "XXXXXXXXXXXX",
  "Arn": "arn:aws:iam::XXXXXXXXXXXX:user/Terraform-user"
}
```

---

## ⚙️ Step 2: Deploy EC2 using Terraform

Initialize Terraform:

```bash
terraform init
```

Validate:

```bash
terraform validate
```

Plan:

```bash
terraform plan
```

Apply:

```bash
terraform apply -auto-approve
```

Get Public IP:

```bash
terraform output public_ip
```

---

## ⚙️ Step 3: Connect to EC2

```bash
chmod 400 Jenkins-key.pem

ssh -i Jenkins-key.pem ec2-user@<PUBLIC-IP>
```

---

## ⚙️ Step 4: Install Node Exporter

```bash
cd /opt

wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz

tar -xvf node_exporter-1.9.1.linux-amd64.tar.gz

cd node_exporter-1.9.1.linux-amd64

./node_exporter &
```

Verify:

```bash
curl localhost:9100/metrics
```

---

## ⚙️ Step 5: Install Prometheus

```bash
cd /opt

wget https://github.com/prometheus/prometheus/releases/download/v3.5.0/prometheus-3.5.0.linux-amd64.tar.gz

tar -xvf prometheus-3.5.0.linux-amd64.tar.gz

cd prometheus-3.5.0.linux-amd64
```

Create Prometheus Configuration:

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - static_configs:
        - targets: []

rule_files:

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]

  - job_name: "node_exporter"
    static_configs:
      - targets: ["localhost:9100"]
```

Create data directory:

```bash
mkdir -p data
chmod -R 777 data
```

Validate Config:

```bash
./promtool check config prometheus.yml
```

Start Prometheus:

```bash
./prometheus \
--config.file=prometheus.yml \
--storage.tsdb.path=data &
```

Verify:

```bash
curl http://localhost:9090/-/healthy
```

---

## ⚙️ Step 6: Install Grafana

```bash
sudo rpm -Uvh https://dl.grafana.com/enterprise/release/grafana-enterprise-12.0.2-1.x86_64.rpm
```

Start Grafana:

```bash
sudo systemctl daemon-reload

sudo systemctl enable grafana-server

sudo systemctl start grafana-server
```

Check Status:

```bash
sudo systemctl status grafana-server
```

---

## ⚙️ Step 7: Access Grafana

Open Browser:

```text
http://<PUBLIC-IP>:3000
```

Default Credentials:

```text
Username: admin
Password: admin
```

---

## ⚙️ Step 8: Configure Prometheus Data Source

Grafana → Connections → Data Sources → Add Data Source

Select:

```text
Prometheus
```

URL:

```text
http://localhost:9090
```

Click:

```text
Save & Test
```

---

## ⚙️ Step 9: Import Dashboard

Grafana → Dashboards → Import

Dashboard ID:

```text
1860
```

Node Exporter Full Dashboard

---

## 📊 Useful PromQL Queries

### CPU Usage

```promql
100 - (avg by(instance)(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Memory Usage

```promql
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
```

### Disk Usage

```promql
100 - (node_filesystem_avail_bytes * 100 / node_filesystem_size_bytes)
```

### Network Receive

```promql
rate(node_network_receive_bytes_total[5m])
```

---

## 🔥 Generate CPU Load

Install Stress:

```bash
sudo dnf install stress -y
```

Generate CPU Load:

```bash
stress --cpu 2 --timeout 300
```

Observe CPU spike in Grafana Dashboard.

---

## 🎯 Skills Demonstrated

* AWS EC2
* Terraform
* Linux Administration
* Prometheus Monitoring
* Grafana Dashboards
* Node Exporter
* Infrastructure as Code (IaC)
* Observability
* SRE Monitoring Practices

---

## 🚀 Future Enhancements

* Alertmanager Integration
* Email Alerts
* Slack Notifications
* Multi-Node Monitoring
* Grafana Alert Rules
* Production-Ready Systemd Services
* CloudWatch Integration
