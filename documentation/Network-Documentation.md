# Network Documentation

## 1. Network Topology Diagram
### **Topology Type:** Point-to-Point (P2P) 

  [Admin Server ]  →  [Target Server]   


## 2. IP Addressing Scheme
| Device     | IP Address       | Subnet Mask       | Role     |
|------------|----------------|----------------|---------|
| **Admin Server** | 10.0.2.13   | 255.255.255.0  | Server 1 |
| **Target Server** | 10.0.2.12   | 255.255.255.0  | Server 2 |

---

## 3. Firewall Rules
### **UFW Rules (If Using UFW)**
```bash
sudo ufw allow 22/tcp  # Allow SSH
sudo ufw enable
```

 4. Service Ports in Use
| Service | Port Number | Protocol |
|---------|------------|----------|
| **SSH** | 2222        | TCP      |
| **Ping (ICMP)** | N/A | ICMP |
| **HTTP** | 80 | TCP |




