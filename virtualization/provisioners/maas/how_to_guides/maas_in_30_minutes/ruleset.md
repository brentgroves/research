# nft ruleset

```bash
sudo nft list ruleset
# Warning: table ip filter is managed by iptables-nft, do not touch!
table ip filter {
	chain INPUT {
		type filter hook input priority filter; policy accept;
		iifname "mpqemubr0" meta l4proto tcp tcp dport 53  counter packets 0 bytes 0 accept
		iifname "mpqemubr0" meta l4proto udp udp dport 53  counter packets 81 bytes 6398 accept
		iifname "mpqemubr0" meta l4proto udp udp dport 67  counter packets 16 bytes 4870 accept
	}

	chain OUTPUT {
		type filter hook output priority filter; policy accept;
		oifname "mpqemubr0" meta l4proto tcp tcp sport 53  counter packets 0 bytes 0 accept
		oifname "mpqemubr0" meta l4proto udp udp sport 53  counter packets 81 bytes 20845 accept
		oifname "mpqemubr0" meta l4proto udp udp sport 67  counter packets 16 bytes 5248 accept
	}

	chain FORWARD {
		type filter hook forward priority filter; policy accept;
		iifname "mpqemubr0" oifname "mpqemubr0"  counter packets 38 bytes 9862 accept
		iifname "mpqemubr0" ip saddr 10.195.222.0/24  counter packets 407011 bytes 26532545 accept
		oifname "mpqemubr0" ip daddr 10.195.222.0/24 ct state related,established  counter packets 1390778 bytes 2085410623 accept
		iifname "mpqemubr0"  counter packets 0 bytes 0 reject
		oifname "mpqemubr0"  counter packets 0 bytes 0 reject
	}
}
# Warning: table ip mangle is managed by iptables-nft, do not touch!
table ip mangle {
	chain POSTROUTING {
		type filter hook postrouting priority mangle; policy accept;
		oifname "mpqemubr0" meta l4proto udp udp dport 68  counter packets 16 bytes 5248 xt target "CHECKSUM"
	}
}
# Warning: table ip nat is managed by iptables-nft, do not touch!
table ip nat {
	chain POSTROUTING {
		type nat hook postrouting priority srcnat; policy accept;
		ip saddr 10.195.222.0/24 ip daddr != 10.195.222.0/24  counter packets 236 bytes 19295 masquerade
		meta l4proto udp ip saddr 10.195.222.0/24 ip daddr != 10.195.222.0/24  counter packets 0 bytes 0 masquerade to :1024-65535
		meta l4proto tcp ip saddr 10.195.222.0/24 ip daddr != 10.195.222.0/24  counter packets 0 bytes 0 masquerade to :1024-65535
		ip saddr 10.195.222.0/24 ip daddr 255.255.255.255  counter packets 0 bytes 0 return
		ip saddr 10.195.222.0/24 ip daddr 224.0.0.0/24  counter packets 0 bytes 0 return
	}
}
```