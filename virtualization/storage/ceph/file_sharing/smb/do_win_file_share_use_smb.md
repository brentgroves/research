# do windows file server shares use the smb protocol

Yes, Windows file server shares use the Server Message Block (SMB) protocol, which is the default and native file-sharing protocol for the Windows ecosystem. SMB handles the communication for accessing shared files and printers over a network, with modern versions of the protocol using TCP port 445 for secure and efficient transmission.
Key points about SMB and Windows file shares:
Native Protocol:
SMB is deeply integrated into Windows and is the standard for file sharing within Windows environments.
Purpose:
It allows clients to access data and resources on a server, enabling centralized data management and file sharing.
Modern Usage:
Current versions of SMB (like SMB 3.1.1) run over TCP/IP, primarily on port 445.
Security:
Windows offers enhanced security features within SMB, such as encryption and signing, to protect shared data from interception and unauthorized access.
Dialects:
Different versions of the protocol, known as dialects (e.g., SMB 3.0, SMB 3.1.1), exist, with newer versions providing more robust security and features.
