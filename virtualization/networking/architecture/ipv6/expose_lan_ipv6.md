# Expose ipv6 devices

## references

<https://serverfault.com/questions/1076783/configuring-ipv6-to-expose-local-devices-to-the-internet>

## Configuring IPv6 to expose local device(s) to the internet

I am trying to expose a local client to the net to host a website. I am struggling to understand IPv6.

Current setup:

ISP --> bridged ISP router --> TP-Link router --> LAN

I've configured the TP-Link router to use IPv6. In the router's menu I see:

The "global address" under "IPv6/WAN" is

XXXX:YYY:ZZZ:aaa:RRRR:TTTT:UUUU:VVVV

The "LAN IPv6 address" under "IPv6/LAN" is

XXXX:YYE:ZZZ:aaa:<some local address>
