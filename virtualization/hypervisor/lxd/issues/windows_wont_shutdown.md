# **[windows wont shutdown](https://www.youtube.com/watch?v=hMK5lM4uFk0)**

- **[fix windows system file](https://www.youtube.com/watch?v=acxCueZ2dVQ)**

from control panel
select power options
select change advanced power settings
scroll down to pci express and select
under link state power management
click drop down and set to off
select apply and ok
open cmd prompt as admin

```bash
# The following disables hibernation
powercfg -h off
# If you ever want to to turn it back on 
# powercfg -h on
sfc /scannow
# complete the scan
```

once scan is complete restart your computer
