# DS-Lite config with OpenBSD

[Japanese version](README_ja.md)

In Japan, DS-Lite(RFC6333) is used for IPv4 over IPv6.
This is a memo of DS-Lite config with OpenBSD 7.0/7.1 router.

## Reference
- https://techlog.iij.ad.jp/contents/dslite-macosx (In Japanese)
- https://mano.xyz/post/2018-12-02-openbsd-ipv6-ipoe/ (In Japanese)
- https://xw.is/wiki/OpenBSD_HE_IPv6_tunnel (IPv6 over IPv4)

## Notation
An interface on WAN is `WAN0`, an interface on LAN is `LAN1`.  Please replace them with real names of interfaces like `re0`.

## Files

- [scripts/boot_config](scripts/boot_config) : commands to set tunnel interface on boot
- [scripts/WAN0_ipv6privacy.sh](scripts/WAN0_ipv6privacy.sh) : A script to get IPv6 temporary address of WAN0.
- [scripts/gwi_address.sh](scripts/gwi_address.sh) : A script to change tunnel config when IPv6 address is changed.

## Config
As far as I checked, There is no ND proxy for OpenBSD (except lite-version nd-reflector https://mano.xyz/post/2021-10-31-openbsd-nd-proxy/). If you want to use IPv6 from client, IPv6-IPv6 NAT must be configured and `net.inet6.ip6.forwarding=1` must be set in sysctl.conf.

WAN0 interface must be setup with `inet6 autoconf temporary`.

It is not need to change config of LAN1 interface (IPv4 router).  If you need, configure IPv6 address and rad(8).  MTU/MSS must be `1454`/`1414` if you use DS-Lite with PPPoE.  If only DS-Lite, `MTU 1460`/`MSS 1420`.  Be careful that resolvd sets DNS server of PPPoE to resolv.conf from OpenBSD 7.1.

[scripts/boot_config](scripts/boot_config) configures a tunnel interface.  It must be executed on boot.  rc.local is used to add local boot sequence, but daemons launched before rc.local like unbound may say warings about no connection to the internet.  To suppress, the script must be executed just before those deamons by modifying /etc/rc.

IPv6 address configured with temporary is invalidated in some period.  [scripts/gwi_address.sh](scripts/gwi_address.sh) must be executed in proper period to use newly assigned IPv6 address.

MSS of tunnel interface must be set in pf.conf like `match on gif0 scrub (random-id max-mss 1414)`.  If you use IPv6-IPv6 NAT, its configuration must be set in pf.conf.

## FAQ
Q. Is it OK changing IPv6 address for tunnel when it is being used in connection?

A. I think active TCP connection will be disconnected (I have not experimented).  It may be OK if it is executed at midnight (no usage time)...
