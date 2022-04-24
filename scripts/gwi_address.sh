#!/bin/sh

# XXXX:XXXX is DS-Lite gateway address.
# Ref. mfeed(transix) : https://www.mfeed.ad.jp/transix/dslite/yamaha.html 
ifconfig gif0 inet6 tunnel `sh /root/WAN0_ipv6privacy.sh` XXXX:XXXX prefixlen 128
