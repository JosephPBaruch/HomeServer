# Traefik and k3s Configuration Guide

This guide covers the following topics:
- Removing k3s and starting fresh
- Configuring Traefik to expose an additional port (8081)
- Creating an Ingress resource to work with the custom Traefik port
- Restarting Traefik
- Testing the configuration with `curl`
- Configuring UFW to allow access on port 8081

---

## 1. Removing k3s and Starting Fresh

### 1.1 Stop k3s Services
Stop the k3s server (and agent, if applicable):

```bash
sudo systemctl stop k3s
```

For an agent node:

```bash
sudo systemctl stop k3s-agent
```

### 1.2 Run the Uninstall Script
If you installed k3s using the official installation script, run:

- **For a k3s server node:**

  ```bash
  sudo /usr/local/bin/k3s-uninstall.sh
  ```

- **For a k3s agent node:**

  ```bash
  sudo /usr/local/bin/k3s-agent-uninstall.sh
  ```

### 1.3 Remove Residual Files (Optional)
Remove any leftover configuration or data:

```bash
sudo rm -rf /etc/rancher/k3s
sudo rm -rf /var/lib/rancher/k3s
```

### 1.4 Reinstall k3s
To install k3s fresh, run the official install script:

```bash
curl -sfL https://get.k3s.io | sh -
```

Verify that k3s is running:

```bash
sudo systemctl status k3s
```

---

## 2. Configuring Traefik to Expose Port 8081

By default, Traefik listens on ports 80 (HTTP) and 443 (HTTPS). To add port 8081, update both the Traefik Service and Deployment.

### 2.1 Update the Traefik Service
Edit the Traefik service to expose port 8081:

```bash
kubectl -n kube-system edit service traefik
```

Under the `spec.ports` section, add:

```yaml
- name: custom
  port: 8081
  targetPort: 8081
  protocol: TCP
```

The full `ports` section should look like:

```yaml
ports:
  - name: web
    port: 80
    targetPort: 80
    protocol: TCP
  - name: websecure
    port: 443
    targetPort: 443
    protocol: TCP
  - name: custom
    port: 8081
    targetPort: 8081
    protocol: TCP
```

### 2.2 Update the Traefik Deployment
Edit the Traefik deployment to listen on the new port:

```bash
kubectl -n kube-system edit deployment traefik
```

#### Add a New Container Port
Under the container’s `ports` section, add:

```yaml
- containerPort: 8081
  name: custom
```

#### Add a New Entrypoint Argument
Modify the container’s startup arguments to include the new entrypoint. For example, if your current args are:

```yaml
args:
  - "--entryPoints.web.address=:80"
  - "--entryPoints.websecure.address=:443"
```

Add the custom entrypoint:

```yaml
args:
  - "--entryPoints.web.address=:80"
  - "--entryPoints.websecure.address=:443"
  - "--entryPoints.custom.address=:8081"
```

Save your changes so that Traefik starts listening on port 8081.

---

## 3. Ingress Configuration for Your Application

Create or update your Ingress resource so that Traefik routes requests from all entrypoints (including the new `custom` entrypoint):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  namespace: my-app
  annotations:
    traefik.ingress.kubernetes.io/router.entrypoints: "web,websecure,custom"
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-service
            port:
              number: 80
```

Apply the Ingress:

```bash
kubectl apply -f ingress.yaml
```

---

## 4. Restarting Traefik

If Traefik does not automatically pick up the changes, restart it manually:

```bash
kubectl rollout restart deployment traefik -n kube-system
```

---

## 5. Testing the Configuration

### 5.1 Testing on Localhost
Use `curl` to test the new port locally:

```bash
curl -v http://localhost:8081/frontend
```

### 5.2 Testing with Server IP
If your server’s IP is `192.168.254.45`, test it with:

```bash
curl -v http://192.168.254.45:8081/frontend
```

Or open in your browser:

```
http://192.168.254.45:8081/frontend
```

---

## 6. Configuring UFW (Uncomplicated Firewall)

### 6.1 Allow a Specific IP Address
To allow access to port 8081 from a specific IP (replace `203.0.113.45` with the desired IP):

```bash
sudo ufw allow from 203.0.113.45 to any port 8081 proto tcp
```

### 6.2 Allow All IPs (Optional)
To allow access from any IP:

```bash
sudo ufw allow 8081/tcp
```

Check the firewall status:

```bash
sudo ufw status verbose
```

---

Keep this file as a reference for future configuration changes or troubleshooting.
