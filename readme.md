# 🔐 Keycloak Auth Stack on Azure VM

## 📦 Overview

This project sets up a secure authentication stack using **Keycloak**, **PostgreSQL**, and **NGINX** on an **Azure VM** using Docker Compose and Ansible.

- 🔧 **Terraform**: Creates the Azure infrastructure.
- 🛠️ **Ansible**: Configures the VM and deploys Docker-based services.
- 🚀 **Docker Compose**: Orchestrates Keycloak, PostgreSQL, and NGINX.

---

## 🧱 Component Justification

### ✅ Why these components?

| Component   | Reason |
|-------------|--------|
| **Keycloak** | Industry-standard open-source identity and access management solution. Supports SSO, OAuth2, OpenID Connect, SAML. |
| **PostgreSQL** | Officially supported database for Keycloak with solid performance and reliability. |
| **NGINX** | Acts as a reverse proxy and TLS termination point. Simplifies handling HTTPS certificates and routing. |

### 🚫 Why not other components?

- **OAuth2 Proxy** was **not used** in this version. The current deployment assumes that Keycloak directly handles authentication and HTTPS. This simplifies the architecture and reduces complexity unless additional authorization middleware is required.

- **Traefik or Caddy**: NGINX was chosen due to better familiarity and tighter control over TLS and proxy configuration.

---

## 🖼️ Docker Images

| Service     | Image |
|-------------|-------|
| **Keycloak** | `quay.io/keycloak/keycloak:22.0.5` |
| **PostgreSQL** | `postgres:16` |
| **NGINX** | `nginx:alpine` |

All are official and stable images chosen for production-readiness and community support.

---

## 🌐 Network Configuration

- Docker Compose default bridge network is used.
- **NGINX** listens on port `443` and proxies to Keycloak.
- SSL certificates (`cert.pem`, `key.pem`) are mounted into the container.
- Keycloak runs on port `8443` internally (not exposed) and is proxied by NGINX.

---

## 🚀 GitHub Actions

This repository contains the following GitHub Actions workflows:

| Workflow | Purpose |
|----------|---------|
| **rollout.yml** | Uses Terraform to provision Azure VM infrastructure |
| **configure.yml** | Runs Ansible to configure Docker and deploy services |
| **teardown.yml** | Uses Terraform to destroy the Azure resources |

---

## ✅ Next Steps

- ✅ Setup and commit valid TLS certs to `nginx/certs/`
- ✅ Configure domain and DNS for VM public IP
- 🚀 Run `rollout`, then `configure`
- 🧪 Access Keycloak via `https://<your-domain>`

---

## 🧽 Cleanup

Run the `teardown.yml` workflow to remove all Azure resources when finished.

---

## 👨‍💻 Author

Created by Nemanja Josipović for the Hylastix assignment.



