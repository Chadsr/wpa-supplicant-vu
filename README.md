# wpa-supplicant-vu
wpa-supplicant config for the Vrije Universiteit Amsterdam (VU)

## Usage
You can reference the config in your /etc/network/interfaces.

For example:
```
auto wlan0
iface wlan0 inet dhcp
     wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

The same configuration should work for eduroam, as well (but I have not tested this fully).
