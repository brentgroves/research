# NAT

## references

<https://www.comptia.org/content/guides/what-is-network-address-translation>

## What Is NAT?

What is Network Address TranslationNAT stands for network address translation. It’s a way to map multiple private addresses inside a local network to a public IP address before transferring the information onto the internet. Organizations that want multiple devices to employ a single IP address use NAT, as do most home routers. If you’re connecting from your home right now, chances are your cable modem or DSL router is already providing NAT to your home.

## How Does NAT Work?

Let’s say that there is a laptop connected to a home network using NAT. That network eventually connects to a router that addresses the internet. Suppose that someone uses that laptop to search for directions to their favorite restaurant. The laptop is using NAT. So, it sends this request in an IP packet to the router, which passes that request along to the internet and the search service you’re using. But before your request leaves your home network, the router first changes the internal IP address from a private local IP address to a public IP address. Your router effectively translates the private address you’re using to one that can be used on the internet, and then back again. Now you know that your humble little cable modem or DSL router has a little, automated translator working inside of it.

If the packet keeps a private address, the receiving server won’t know where to send the information back to. This is because a private IP address cannot be routed onto the internet. If your router were to try doing this, all internet routers are programmed to automatically drop private IP addresses. The nice thing is, though, that all routers sold today for home offices and small offices can readily translate back and forth between private IP address and publicly-routed IP addresses.

## What are Private IP Addresses?

As the internet became more popular years ago, the organization that manages IP addresses, known as the Internet Assigned Numbers Authority (IANA) realized that they needed to do something. So, they created a network address translation scheme. This scheme is described in a document called Request for Comments (RFC) 1918. This is just one document of thousands that define how the internet works. If you want to learn about NAT, this is the document that all router manufactures must implement. No matter what type of NAT you use, you will be using RFC 1918 addresses.

If you were to try to send an RFC 1918 private IP address onto the internet, it would be much like sending a physical piece of mail with the return address of “anonymous,” yet requesting return service notification. If you were to try doing that with a snail mail service, you would never get that return service notification, because the service wouldn’t be able to tell where “anonymous” even is.

## NAT Types

There are three different types of NATs. People and organizations use them for different reasons, but they all still work as a NAT.

### Static NAT

When the local address is converted to a public one, this NAT chooses the same one. This means there will be a consistent public IP address associated with that router or NAT device.

### Dynamic NAT

Instead of choosing the same IP address every time, this NAT goes through a pool of public IP addresses. This results in the router or NAT device getting a different address each time the router translates the local address to a public address.

### PAT

PAT stands for port address translation. It’s a type of dynamic NAT, but it bands several local IP addresses to a singular public one. Organizations that want all their employees’ activity to use a singular IP address use a PAT, often under the supervision of a network administrator.

## Why Use NAT?

NAT is a straightforward process. Most routing equipment you purchase at a store will implement it automatically, or with a simple click of a mouse. Let’s get a bit deeper into NAT’s role in IP conservation and explain its limited role in providing security services.

### IP Conservation

IP addresses identify each device connected to the internet. The existing IP version 4 (IPv4) uses 32-bit numbered IP addresses, which allows for 4 billion possible IP addresses, which seemed like more than enough when it launched in the 1970s.

However, the internet has exploded, and while not all 7 billion people on the planet access the internet regularly, those that do often have multiple connected devices: Phones, personal desktop, work laptop, tablet, TV, even refrigerators.

Therefore, the number of devices accessing the internet far surpasses the number of IP addresses available. Routing all of these devices via one connection using NAT helps to consolidate multiple private IP addresses into one public IP address. This helps to keep more public IP addresses available even while private IP addresses proliferate.

### IPv6: More Addresses and Routing Efficiency

On June 6, 2012, IP version 6 (IPv6) officially launched after decades of development. IPv6 was created for many reasons. One of them was to accommodate the need for more IP addresses. This is because traditional NAT itself couldn’t quite keep up with demand. IPv6 uses 128-bit numbered IP addresses, which allow for exponentially more potential IP addresses than IPv4. It will take many years before this process finishes; so until then, using NAT for IPv4 addresses will remain a common practice. More importantly, though, IPv6 does more than just provide a (much) larger IP address space. IPv6 also makes routing much more efficient. For example, IPv6 doesn’t put the burden on routers to process traffic as much as IPv4 does.

### NAT and Security

NAT and private IP addressing are not security services per se. But the use of NAT and private IP addresses is often perceived as a first step towards security. Because NAT transfers packets of data from public to private addresses, it also helps prevent outside computers from directly accessing your private device. For example, an individual on the internet would not be able to use ping or a Web browser to connect to your home computer, unless you created a very specific mapping.

Still, it is important to understand that in and of itself, NAT does not provide security services, such as firewalling, monitoring, antivirus protection, intrusion detection, application security or zero trust services. It is best to consider NAT as a service that conserves and organizes IP addresses, rather than securing information or privacy. Part of the confusion about whether or not NAT provides security services is that it implements private IP addresses. It might seem natural to assume that the term private implies security and privacy. But in almost every practical way, NAT does not provide security services. Instead, it allows you to use RFC 1918 addresses.

If you’re interested in learning more about NAT, IPv6 and even security, it’s best if you learn about these things in a hands-on, practical way. One way to start is to take a look at the CompTIA Infrastructure Pathway.
