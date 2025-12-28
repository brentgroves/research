# **[header filter](https://lists.wireshark.org/archives/wireshark-users/201003/msg00024.html)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

Or if your capturing device is capable of interpreting tcpdump style filters (or more accurately, BPF style filters), you could use:

tcp[(((tcp[12:1] & 0xf0) >> 2) + 8):2] = 0x2030

Which in English would be:

- take the upper 4 bits of the 12th octet in the tcp header ( tcp[12:1] & 0xf0 )
- multiply it by four ( (tcp[12:1] & 0xf0)>>2 ) which should give the tcp header length
- add 8 ( ((tcp[12:1] & 0xf0) >> 2) + 8 ) gives the offset into the tcp header of the space before the first octet of the response code
- now take two octets from the tcp stream, starting at that offset ( tcp[(((tcp[12:1] & 0xf0) >> 2) + 8):2]  )
- and verify that they are " 0" ( = 0x2030 )

Of course this can give you false positives, so you might want to add a test for "HTTP" and the start of the tcp payload with:

tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x48545450

resulting in the filter:

tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x48545450 and tcp[(((tcp[12:1] & 0xf0) >> 2) + 8):2] = 0x2030

A bit cryptic, but it works, even when TCP options are present (which would mess up a fixed offset into the tcp data).
