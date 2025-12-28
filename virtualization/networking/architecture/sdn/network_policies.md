# **[Network Polices](https://www.splunk.com/en_us/blog/learn/control-plane-vs-data-plane.html#:~:text=and%20cloud%20computing.-,Software%2Ddefined%20networking%20(SDN),inputs%20from%20the%20control%20plane.)**

## references

- **[Control plane vs. data plane: use cases](https://www.splunk.com/en_us/blog/learn/control-plane-vs-data-plane.html#:~:text=and%20cloud%20computing.-,Software%2Ddefined%20networking%20(SDN),inputs%20from%20the%20control%20plane.)**

- **[data plane](https://www.techtarget.com/searchnetworking/definition/data-plane-DP#:~:text=The%20stoplights%20at%20the%20intersection,where%20packets%20will%20be%20transported.)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## Cisco definition

Network policy is a collection of rules that govern the behaviors of network devices. Just as a federal or central government may lay down policies for state or districts to follow to achieve national objectives, network administrators define policies for network devices to follow to achieve business objectives.

### What do policies govern?

Policies don't exist in a vacuum. All network devices, users, and applications should be governed by those policies.

- **Users** - Effective policies need to recognize all types of users. Clearly, an admin user should have different rights and be able to do a wider array of tasks on the network than a guest user. Likewise, a financial user needs access to business-critical financial data, while a security guard does not.
- **User and IoT devices** - Access privileges provided to devices form key policies, especially as IoT expands. A policy could enable people to perform more tasks and access more types of information than a connected temperature sensor or printer. In fact, policies should expressly prohibit a moisture sensor from accessing a financial database.
- **Applications** - Not all applications are equal, and policies should reflect that. Bandwidth is always limited, so polices should prioritize traffic from business-critical applications over traffic from social media, for example.
- **Data Type** - Similarly, not all data types are of equal importance. Critical financial data demands a more restrictive policy. Video traffic may demand a specific quality-of-service (QoS) policy to help optimize performance levels.
- **Location** - Location can be an important policy attribute. As telecommuting becomes more widespread, users' locations may affect their security profiles and what applications and data they can access. For example, a user may access a human resources data base from the privacy of their home office, but not while working from a public coffee shop.
