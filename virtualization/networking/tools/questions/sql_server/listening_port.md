# **[How to check if SQL Server is listening on a dynamic port or static port](https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/connect/static-or-dynamic-port-config)**

This article discusses how to determine whether your Microsoft SQL Server named instance is listening on a dynamic port versus a static port. This information can be helpful when you troubleshoot different connection issues that are related to SQL Server.

By default, a SQL Server named instance is configured to listen on dynamic ports. It gets an available port from the operating system. You can also configure SQL Server named instances to start at a specific port. This is known as a static port. For more information about static and dynamic ports in the context of SQL Server, see Static vs Dynamic Ports.

Use the following procedure to determine whether the SQL Server named instance is listening on a dynamic port versus a static port.

## Option 1: Use SQL Server Configuration Manager

1. In SQL Server Configuration Manager, expand SQL Server Network Configuration, expand Protocols for instance name, and then double-click TCP/IP.

2. In TCP/IP Properties, select Protocol.

3. Check the value in the Listen All setting. If it's set to Yes, go to step 4. If it's set to No, go to step 6.

4. Go to IP Addresses, and scroll to the bottom of the TCP/IP Properties page.

5. Check the values in IP All, and use the following table to determine whether the named instance is listening on a dynamic or static port.

    | TCP dynamic ports | TCP port  | SQL Server instance using dynamic or static ports?                                     |
    |-------------------|-----------|----------------------------------------------------------------------------------------|
    | Blank             | Blank     | Dynamic ports                                                                          |
    | Number          | Blank     | Dynamic ports - Number is the dynamic port that SQL Server is currently listening on |
    | Number1         | Number2 | Concurrently listening on a dynamic port Number1 and a static port Number2         |

6. Switch to IP Addresses. Notice that several IP addresses appear in the format of IP1, IP2, up to IP All. One of these IP addresses is intended for the loopback adapter, 127.0.0.1. More IP addresses appear for each IP address on the computer. (You will probably see both IP4 and IP6 addresses.) To check whether a specific IP address is configured for a dynamic versus static port, use the following table.

    | TCP dynamic ports | TCP port  | SQL Server instance using dynamic or static ports?                                     |
    |-------------------|-----------|----------------------------------------------------------------------------------------|
    | Blank             | Blank     | Dynamic ports                                                                          |
    | Number          | Blank     | Dynamic ports - Number is the dynamic port that SQL Server is currently listening on |
    | Number1         | Number2 | Concurrently listening on a dynamic port Number1 and a static port Number2         |

A value of 0 in TCP dynamic ports indicates that the named instance is currently not running and is configured for dynamic ports. After you start the instance, the value field will reflect the dynamic port that the instance is currently using.

## **[Get Instance Name](https://learn.microsoft.com/en-us/troubleshoot/sql/database-engine/connect/network-related-or-instance-specific-error-occurred-while-establishing-connection#get-the-instance-name-from-configuration-manager)**
