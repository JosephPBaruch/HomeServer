# Cloudflare Commands and Help

## Commands 

### Create a Tunnel 

cloudflared tunnel create <tunnelName>

> Once the tunnel is created, you will need to modify or create a config with the tunnel id. 
> You will also be required to configure cloudflare DNS records to identify the correct tunnel.

### Start a Tunnel 

cloudflare tunnel run <tunnel_name>

#### Run in the background 

nohup cloudflared tunnel run <tunnelName> > cloudoutput.log 2>&1 &

### Kill a Tunnel

ps aux | grep "cloudflared tunnel run <tunnelName>

> Then you will need to get the PID and kill it. 

kill -9 <PID>



