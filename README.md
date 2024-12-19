# DS-Lite config with OpenBSD

[Japanese version](README_ja.md)

In Japan, DS-Lite(RFC6333) is used for IPv4 over IPv6.
This is a memo of DS-Lite config with OpenBSD 7.5/7.6 router.

## Reference
- https://www.openbsd.org/faq/pf/example1.html (OpenBSD PF router guide)
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
As far as I have checked, there is no ND proxy for OpenBSD (except lite-version nd-reflector https://mano.xyz/post/2021-10-31-openbsd-nd-proxy/). If you want to use IPv6 from client, IPv6-IPv6 NAT must be configured and `net.inet6.ip6.forwarding=1` must be set in sysctl.conf.

WAN0 interface must be setup with `inet6 autoconf temporary`.

It is not necessary to change config of LAN1 interface (IPv4 router).  If you need IPv6, configure IPv6 address and rad(8).  MTU/MSS must be `1454`/`1414` if you want to use DS-Lite with PPPoE.  If only DS-Lite, `MTU 1460`/`MSS 1420`. 

MSS of tunnel interface must be set in `pf.conf` like `match on gif0 scrub (random-id max-mss 1414)`.  If you will use IPv6-IPv6 NAT, its configuration must be set in `pf.conf`.

Note that resolvd sets DNS server of PPPoE to resolv.conf from OpenBSD 7.1.

[scripts/boot_config](scripts/boot_config) configures a tunnel interface.  It must be executed on boot.  rc.local is used to add local command execution at the end of boot sequence, but daemons started before rc.local, such as unbound, may warn that there is no connection to the Internet.  To suppress this, the script must be executed just before these daemons by modifying `/etc/rc`.

IPv6 address configured with `temporary` is invalidated in some period.  [scripts/gwi_address.sh](scripts/gwi_address.sh) must be executed in appropriate period to use newly assigned IPv6 address.

## FAQ
Q. Is it OK changing IPv6 address for tunnel when it is being used in connection?

A. I think active TCP connection will be disconnected (I have not experimented).  It may be OK if it is executed at midnight (when not used)...
