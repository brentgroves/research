# **[Ceph vs Acropolis Operating System storage](https://forum.proxmox.com/threads/nutanix-vs-proxmox-with-ceph.137109/#:~:text=With%20manufacturers%20like%20EMC%20or,pools%20the%20way%20you%20want.)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../a_status/detailed_status.md)**\
**[Back to Main](../../../../README.md)**

Acropolis Operating System (AOS) is an operating system for the Nutanix hyper-converged infrastructure platform. AOS contains data services for data protection, space efficiency, scalability, automated data tiering and security. AOS comes with a built-in hypervisor called Acropolis Hypervisor (AHV).

I don't know Nutanix too well to make a real statement. But Nutanix will fundamentally be no different than NetApp or EMC. So you have dedicated storage that uses manufacturer-specific components and possibly even protocols. If the performance is no longer enough for you, something breaks or support has expired, then you're usually just left with a big pile of electronic scrap lying around, which usually only brings you 2 - 3% of the purchase price on eBay .I know from EMC that features like Dedup etc. were directly integrated and worked well. The tiering issue was also problem-free. So I'm not saying that such storage systems are bad or junk - but you are simply locked in the world of this manufacturer and no longer free to use the product.

I am a very big friend of CEPH, so you will mostly hear positive things from me. First and foremost, you have to get an idea of the solutions yourself, because you will be responsible for them later. So you should look for a solution that you feel comfortable with and can handle.

At CEPH you have the great advantage that you can: For example, you can set up an HCI setup so that you can use the same nodes for computing, network and storage and you don't need any additional infrastructure to provide the storage. Especially when it comes to hosting, price is important, so that's definitely a plus point for CEPH.

With CEPH you can basically use any hardware you want, it will actually always work - whether it's good or bad depends on the components you choose. I would always recommend using Enterprise SSDs / NVMe and switches that can do MLAG (e.g. Arista or Juniper QFX5100), but never Juniper VC or other proprietary nonsense. With manufacturers like EMC or Nutanix, you will always have to purchase the SSDs from the manufacturer so that your support remains intact.

You can configure freely in CEPH, you can save storage space with erasure coding or design the replication of the pools the way you want. CEPH also scales across multiple data centers or server rooms. For example, you can instruct CEPH to have one replication per rack.So you can start with 6 nodes, divide them into 3 racks and adjust the crush map accordingly. You usually can't do that with such solutions from Nutanix, but you'll always need your own controllers in the respective rack.

There was also a function with tiering (primary affinity) in CEPH, but that has actually been eliminated with Flash Only. I would also advise you to do that, at least start with SSDs or directly NVMe. However, if your nodes have enough bays, you can also install SSDs and HDDs in the same node and divide the data between these two classes. CEPH doesn't do any tiering in this sense, but you can decide which data is where and simply move the virtual disk.

But CEPH is also very extensive and complex, you just have to be clear about certain factors. If you have a problem, you usually cannot access a support hotline but are responsible for it yourself. Of course, there are service providers who can help you, but usually no one will come to your location, as could be the case with EMC, for example.You also have to monitor the CEPH storage yourself very extensively in order to be able to react to problems at an early stage. There are tools here and there, but overall you have to set it up for yourself and define threshold values.
