# extreme

## Network frame

In networking, a network frame is a structured unit of data, like an envelope, that encapsulates the data being transmitted between network devices. It's the fundamental building block of data transmission at the data link layer (Layer 2) of the OSI model. Frames include headers and trailers that provide control information for efficient and reliable data transmission.

## Port configuration

- tagged means the host does the tagging
- untagged means the switch does the tagging

## Packet Flow

- source host creates network frame
- If the port is configured with an untagged VLAN then
  - switch tags untagged frame header with a VLAN ID.
- If the port is configured with a tagged VLAN then
  - the host has added the VLAN ID to the frame header
- Switch passes frame to ports configured to accept frames configured with that VLAN ID.
  - Switch removes VLAN ID from frame header before passing frames to port.

## 220-12p-10ge2 12 port switch

- access http configuration UI using switches IP
  - admin/no password

10.188.10.111

## Extreme Edge Switches

- telnet access with username and password restricted access.

## Top Extreme Edge Switch

- port 28
  - untagged  
  - tagged
    - 50
    - 220
- port 29
  - untagged  
  - tagged
    - 50
    - 220
- port 30
  - untagged  
    - 1220
  - tagged
- port 31
  - untagged  
  - tagged
    - 50
    - 220

### R620 top

name: k8sgw3
link: eno1
port: 1 (left side)
ip:
    - 10.188.50.203
    - 10.188.220.203
    - 10.187.220.203 (no access)

### R620 Middle

name: k8sgw2
link: eno1
port: 1 (left side)
ip:
    - 10.188.50.202
    - 10.188.50.214

### R620 Bottom

name: k8sgw1
link: eno1
port: 1 (left side)
ip:
    - 10.188.50.201
    - 10.188.220.201
