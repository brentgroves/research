# **[IP Set](https://ipset.netfilter.org/#:~:text=express%20complex%20IP%20address%20and,the%20speed%20of%20IP%20sets)**

IP sets are a framework inside the Linux kernel, which can be administered by the ipset utility. Depending on the type, an IP set may store IP addresses, networks, (TCP/UDP) port numbers, MAC addresses, interface names or combinations of them in a way, which ensures lightning speed when matching an entry against a set.

If you want to

- store multiple IP addresses or port numbers and match against the collection by iptables at one swoop;
- dynamically update iptables rules against IP addresses or ports without performance penalty;
- express complex IP address and ports based rulesets with one single iptables rule and benefit from the speed of IP sets
then ipset may be the proper tool for you.

IP sets was written by Jozsef Kadlecsik and it is based on ippool by Joakim Axelsson, Patrick Schaaf and Martin Josefsson.
Many thanks to them for their wonderful work!

## **[Temporary iptables changes](https://superuser.com/questions/701042/temporary-iptables-changes)

Is there some way I can make changes to iptables (like changing the default rule to DROP) with say a 5 minute timeout, so if I do get a change wrong and lock everyone out, I can just wait a while and try again?

You can also use the `at` command to execute a script that will remove your rule after a period of time. This way even if your public ip changes, you could still log back in. –

Use a iptables front end that has this feature. For example Firehol has the firehol try fuction.

Most linux distributions come with the **[iptables-apply](http://man.he.net/man8/iptables-apply)** script either already installed or available through the package manager. It will allow you to apply a new set of iptables rules, and rollback automatically if you do not confirm that they work within a certain time.

### If you use ipset it can all be automated

ipset create test hash:ip timeout 300

 iptables -A INPUT -p tcp -m tcp -m multiport -m state --state NEW -j SET --add-set test src ! --dports 25,80,993,5900
 iptables -A input_ext -m set -j DROP  --match-set test src
Change the ports option to whatever you want.

Need to save the list between reboots?

   ipset save >backup.txt
Need tor restore?

   ipset restore <backup.txt
Do you want packet bytes counters?

add the keyword counters to the end of the ipset create statement.
