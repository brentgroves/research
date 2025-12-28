sudo iptables -L
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:bootps /* generated for Multipass network mpqemubr0 */

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */
ACCEPT     all  --  10.195.222.0/24      anywhere             /* generated for Multipass network mpqemubr0 */
ACCEPT     all  --  anywhere             10.195.222.0/24      ctstate RELATED,ESTABLISHED /* generated for Multipass network mpqemubr0 */
REJECT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */ reject-with icmp-port-unreachable
REJECT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */ reject-with icmp-port-unreachable

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp spt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp spt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp spt:bootps /* generated for Multipass network mpqemubr0 */

# iptables-nft should be the same as iptables which is linked to iptables-nft

sudo iptables-nft -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp dpt:bootps /* generated for Multipass network mpqemubr0 */

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */
ACCEPT     all  --  10.195.222.0/24      anywhere             /* generated for Multipass network mpqemubr0 */
ACCEPT     all  --  anywhere             10.195.222.0/24      ctstate RELATED,ESTABLISHED /* generated for Multipass network mpqemubr0 */
REJECT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */ reject-with icmp-port-unreachable
REJECT     all  --  anywhere             anywhere             /* generated for Multipass network mpqemubr0 */ reject-with icmp-port-unreachable

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     tcp  --  anywhere             anywhere             tcp spt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp spt:domain /* generated for Multipass network mpqemubr0 */
ACCEPT     udp  --  anywhere             anywhere             udp spt:bootps /* generated for Multipass network mpqemubr0 */

f iptables shows both "accept all" and "reject all" rules, it means your firewall is configured to allow all traffic, but will also send an error message back to the source when it does so, essentially creating a redundant situation where everything is permitted but the system is still notifying the sender that access is being blocked; this is usually a configuration error and should be reviewed to ensure the intended behavior is achieved. 

Reject-with icmp-port-unreachable" in iptables means that when a packet is blocked by a firewall rule, the system will actively send an ICMP "Port Unreachable" message back to the source, notifying the sender that the specified port on the destination device is not accessible

# iptables-legacy

sudo iptables-legacy -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination   