#!/bin/sh
# Note that in OpenBSD 6.9, privacy of ifconfig is renamed to temporary.

# XXXX:XXXX is DS-Lite gateway address.
# Ref. mfeed(transix) : https://www.mfeed.ad.jp/transix/dslite/yamaha.html 
ifconfig gif0 inet6 tunnel `sh /root/WAN0_ipv6privacy.sh` XXXX:XXXX prefixlen 128
