# **[](https://www.reddit.com/r/ccna/comments/a9bwmn/confused_about_ipsec_and_gre/#:~:text=While%20both%20are%20correct%2C%20neither,the%20traffic%20inside%20the%20tunnel.)**

- A VPN is a general term for any number of technologies that join two otherwise distant networks in such a way as they appear local to each other--without having to run a local link. These terms are all vague because they differ in each environment.

The term is more commonly used to refer to two different specific types of VPNs: a client-server encrypted tunnel for remote access ("I need to get onto the corporate VPN to get my email") or a similar use for home users to encrypt or obfuscate their internet traffic ("I use a VPN so my ISP doesn't block YouTube"). While both are correct, neither are the sole use or set up of a VPN. Some of the most common misconceptions are: a VPN does not necessarily imply encryption, nor does a VPN always use the Internet (although both are very, very common).

- GRE is a tunneling technology. GRE allows us to encasulate our privately-addresses traffic as the payload in a publicly-addressed frame. This is one method of creating a VPN, however a GRE tunnel does not necessarily extend a private network. Think of a GRE tunnel as a way of treating connectivity as a local link. That is, as long as we can ping each other, we can pretend there is a cable connecting us. That pretend (virtual) cable is the tunnel.
- IPSEC is a relatively complicated set of technologies used to encrypt network traffic between endpoints. It is usually used in conjunction with a tunnel, but does not require one. When setting up a VPN with privacy as a concern, IPSEC is a common way to ensure that privacy.

Note that one of the more confusing parts of IPSEC and tunnels is that IPSEC can run across the public link, and the tunnel be built "inside" IPSEC, or a tunnel can run across the public link, and IPSEC be run on the traffic inside the tunnel.
