# **[SMB Meets Squid: Introducing the New Ceph SMB Manager Module for SMB Service Management in Ceph](https://ceph.io/en/news/blog/2025/smb-manager-module/#:~:text=Introduction,enjoying%20enhanced%20control%20and%20scalability.)**

Note: Some of the features described are only partially available as of Squid 19.2.3. Complete support will come with Tentacle.

## Introduction

SMB (Server Message Block) is a widely-used network protocol that facilitates the sharing of files, printers, and other resources across a network. To seamlessly integrate SMB services within a Ceph environment, Ceph 8.0 introduces the powerful SMB Manager module, which enables users to deploy, manage, and control Samba services for SMB access to CephFS. This module offers a user-friendly interface for managing clusters of Samba services and SMB shares, with the flexibility to choose between two management methods: imperative and declarative. By enabling the SMB Manager module using the command ceph mgr module enable smb, administrators can efficiently streamline their SMB service operations, whether through the command-line or via orchestration with YAML or JSON resource descriptions. With the new SMB Manager module, Ceph admins can effortlessly extend file services, providing robust SMB access to CephFS while enjoying enhanced control and scalability.

## Managing SMB Cluster and Shares ¶

Admins can interact with the Ceph Manager SMB module using following methods:

Imperative Method: Ceph commands to interact with the Ceph Manager SMB module.

Declarative Method: Resources specification in YAML or JSON format.

## Simple Ceph Squid with SMB Configuration Workflow

![i1](https://ceph.io/en/news/blog/2025/smb-manager-module/images/smb1.png)

## Conclusion ¶

The Ceph SMB Manager module in Ceph Squid brings an innovative and efficient way to manage SMB services for CephFS file systems. Whether through imperative or declarative methods, users can easily create, manage, and control SMB clusters and shares. This integration simplifies the setup of Samba services, enhances scalability, and offers greater flexibility for administrators.With the ability to manage SMB access to CephFS seamlessly, users can now have a streamlined process for providing secure and scalable file services.

The authors would like to thank IBM for supporting the community by facilitating our time to create these posts.
