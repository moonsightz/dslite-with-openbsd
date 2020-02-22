#!/bin/sh
sh /root/WAN0_ipv6privacy.sh
# XXXX:XXXX is gw.transix.jp's address.
# Ref. https://www.mfeed.ad.jp/transix/dslite/yamaha.html
ifconfig gif0 inet6 tunnel `cat /tmp/WAN0_ipv6privacy` XXXX:XXXX prefixlen 128
