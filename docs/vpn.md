# How to set up a VPN server in my local network

## Use this Docker Image

> docker pull linuxserver/wireguard


Setting up a VPN server in your local network depends on your specific use case, but the general process involves:

1. **Choose a VPN Server Software**
   - WireGuard (lightweight, fast, modern)
   - OpenVPN (widely used, more complex)
   - SoftEther VPN (multi-protocol support, user-friendly)
   - IPsec/L2TP (built into many OS, but harder to configure)
   - Pritunl (OpenVPN + WireGuard with a nice GUI)
   - Tailscale (WireGuard-based with easy setup)

2. **Set Up the VPN Server**
   - Install WireGuard on the server:
     ```sh
     sudo apt update && sudo apt install wireguard
     ```
   - Generate key pairs:
     ```sh
     umask 077
     wg genkey | tee privatekey | wg pubkey > publickey
     ```
   - Create the WireGuard configuration file:
     ```sh
     sudo nano /etc/wireguard/wg0.conf
     ```
   - Example `wg0.conf`:
     ```
     [Interface]
     PrivateKey = YOUR_SERVER_PRIVATE_KEY
     Address = 10.0.0.1/24
     ListenPort = 51820

     [Peer]
     PublicKey = CLIENT_PUBLIC_KEY
     AllowedIPs = 10.0.0.2/32
     ```
   - Enable and start the VPN server:
     ```sh
     sudo systemctl enable wg-quick@wg0
     sudo systemctl start wg-quick@wg0
     ```

3. **Configure Router & Firewall**
   - Forward necessary ports to the VPN server.
   - Allow VPN traffic through the firewall:
     ```sh
     sudo ufw allow 51820/udp
     ```

4. **Set Up VPN Clients**
   - Install WireGuard on the client device.
   - Generate a key pair for the client:
     ```sh
     umask 077
     wg genkey | tee client_privatekey | wg pubkey > client_publickey
     ```
   - Create a client config file:
     ```
     [Interface]
     PrivateKey = CLIENT_PRIVATE_KEY
     Address = 10.0.0.2/24

     [Peer]
     PublicKey = SERVER_PUBLIC_KEY
     Endpoint = YOUR_PUBLIC_IP:51820
     AllowedIPs = 0.0.0.0/0
     ```
   - Import this configuration into the WireGuard client.

5. **Connect and Test**
   - Verify connectivity by pinging the VPN server:
     ```sh
     ping 10.0.0.1
     ```
   - Check access to internal network resources.

Would you like a different VPN solution, or do you need help with specific networking issues?

