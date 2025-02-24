# Pi-hole Installation and Setup Guide

## Prerequisites
- A Linux-based system (Raspberry Pi, Ubuntu, Debian, etc.)
- Static IP address for the server
- Internet connection

## 1️⃣ Update System
```sh
sudo apt update && sudo apt upgrade -y
```

## 2️⃣ Install Pi-hole
```sh
curl -sSL https://install.pi-hole.net | bash
```
Follow the setup prompts:
- Choose the network interface (e.g., `eth0`)
- Select an upstream DNS provider (Google, Cloudflare, OpenDNS, etc.)
- Enable IPv4 and/or IPv6 blocking
- Enable web admin interface (recommended)
- Note the admin password displayed at the end of installation

## 3️⃣ Access Web Interface
```sh
http://<YOUR_SERVER_IP>/admin
```
Login with the credentials shown after installation.

## 4️⃣ Set Pi-hole as DNS Server
### Router Configuration (Recommended)
1. Go to your router’s **DNS settings**
2. Set **Primary DNS** to **Pi-hole's IP address**
3. Disable "Automatic DNS" if available

### Manual Device Configuration (Optional)
Change device DNS settings to Pi-hole's IP:
- Windows: `Control Panel -> Network & Internet -> Change Adapter Settings`
- MacOS: `System Preferences -> Network -> Advanced -> DNS`
- Linux: Edit `/etc/resolv.conf`

## Add Custom Blocklists (Optional)
```sh
pihole -a -g
```
You can add blocklists like:
- OISD Blocklist: [https://oisd.nl/](https://oisd.nl/)
- StevenBlack's Blocklist

## Update and Maintain Pi-hole
### Update Pi-hole
```sh
pihole -up
```

### Flush DNS Cache
```sh
sudo systemd-resolve --flush-caches
```

### Restart Pi-hole
```sh
pihole restartdns
```

## Verify Ad Blocking
Visit: [https://ads-blocker.com/testing/](https://ads-blocker.com/testing/)
Check query logs:
```sh
http://<YOUR_SERVER_IP>/admin
```

## Conclusion
Pi-hole is now filtering ads at the network level. For enhanced privacy, consider integrating it with **DNS-over-HTTPS (DoH)** or a VPN.

Would you like help setting up encrypted DNS or VPN integration?

