

sudo vi /etc/systemd/system/k3s.service

ExecStart=/usr/local/bin/k3s server \
    --disable=traefik \
    --service-node-port-range=8000-32000


sudo systemctl daemon-reload
sudo systemctl restart k3s


kubectl apply -f traefik-helmconfig.yaml
kubectl rollout restart deployment/traefik -n kube-system

