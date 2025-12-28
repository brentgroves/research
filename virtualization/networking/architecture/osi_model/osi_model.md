# # **[OSI Model](https://www.geeksforgeeks.org/open-systems-interconnection-model-osi/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![osi](https://media.geeksforgeeks.org/wp-content/uploads/20240615010645/OSI-Model.png)

## Data Flow In OSI Model

When we transfer information from one device to another, it travels through 7 layers of OSI model. First data travels down through 7 layers from the sender’s end and then climbs back 7 layers on the receiver’s end.

Data flows through the OSI model in a step-by-step process:

- Application Layer: Applications create the data.
- Presentation Layer: Data is formatted and encrypted.
- Session Layer: Connections are established and managed.
- Transport Layer: Data is broken into segments for reliable delivery.
- Network Layer : Segments are packaged into packets and routed.
- Data Link Layer: Packets are framed and sent to the next device.
- Physical Layer: Frames are converted into bits and transmitted physically.

Each layer adds specific information to ensure the data reaches its destination correctly, and these steps are reversed upon arrival.
