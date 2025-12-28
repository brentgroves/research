# How to connect to Fortigate Firewall using VPN

To connect to a FortiGate firewall using a VPN, you'll typically use FortiClient for either IPsec or SSL VPN. You'll need to configure the FortiGate to enable VPN and define user groups or users who can connect. Then, on your client device, you'll use FortiClient to connect to the FortiGate's VPN gateway, providing your credentials.

Steps for FortiGate VPN Setup:

1. Enable VPN on the FortiGate:
IPsec VPN: Navigate to VPN > IPsec Wizard in the FortiGate GUI. Create a new tunnel, choose the appropriate template (e.g., Remote Access), configure settings like the remote device type (FortiClient VPN), incoming interface, authentication method (Pre-shared Key), and user group.
SSL VPN: Go to VPN > SSL-VPN Settings. Set the listen interface(s), listen port, configure the server certificate, define IP ranges for SSL VPN clients, and configure user groups and portal mapping.

2. Configure User Groups and Users:
Create user groups and assign them to the VPN profiles.
Add users to the appropriate user groups.
3. Download and Install FortiClient:
Download FortiClient from **[Fortinet](https://www.fortinet.com/products/endpoint-security/forticlient)**.
ZTNA Edition
EPP/APT Edition
FortiClient EMS
FortiClient VPN-only
Install the client on your device.

4. Configure FortiClient:
Open FortiClient and navigate to the remote access settings.
Add a new connection, specifying the VPN type (IPsec or SSL VPN) and the FortiGate's IP address.
Enter the VPN credentials (username, password, and optionally, a two-factor authentication token).

Important Notes:
Firewall Policies:
Ensure your firewall policies allow traffic to and from the VPN tunnel, especially if you're using a split tunnel configuration.
Pre-shared Keys:
If using IPsec with pre-shared keys, ensure both ends of the VPN have the same key.
Split Tunnel:
Decide whether you want full tunnel (all traffic routed through the VPN) or split tunnel (only specific traffic routed through the VPN).
FortiClient Versions:
Ensure you are using a compatible version of FortiClient.
This **[video](https://www.youtube.com/watch?v=Sp4KSILHOWI&t=573)** demonstrates how to configure IPsec VPN on a FortiGate firewall:

## Install Fortigate 7.4 Client Ubuntu 22.04

```bash
Ubuntu 22.04 LTS
Install gpg key
wget -O - https://repo.fortinet.com/repo/forticlient/7.4/ubuntu22/DEB-GPG-KEY | gpg --dearmor | sudo tee /usr/share/keyrings/repo.fortinet.com.gpg
Create /etc/apt/sources.list.d/repo.fortinet.com.list with the following content
deb [arch=amd64 signed-by=/usr/share/keyrings/repo.fortinet.com.gpg] https://repo.fortinet.com/repo/forticlient/7.4/ubuntu22/ stable non-free
Update package lists
sudo apt-get update
```
