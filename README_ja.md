# DS-Lite config with OpenBSD

[English version](README.md)

OpenBSD 6.6/6.7/6.8 router で DS-Lite を使えるようにする設定（NTT な環境を想定）


## Reference
- [てくろぐ : DS-Lite(RFC6333)をMacOS Xで利用する](https://techlog.iij.ad.jp/contents/dslite-macosx)
- [OpenBSDでIPv6 IPoEを設定したときのメモ](https://mano.xyz/post/2018-12-02-openbsd-ipv6-ipoe/)
- [OpenBSD HE IPv6 tunnel](https://xw.is/wiki/OpenBSD_HE_IPv6_tunnel) (IPv6 over IPv4)

## Notation

WAN 側の interface を `WAN0`、LAN 側の interface を `LAN1` と表記します。スクリプトも含めて適宜各自の環境に合わせて `re0` などのインターフェース名に置き換えて下さい。

## Files

- [scripts/boot_config](scripts/boot_config) : 起動時に tunnel を設定するコマンド
- [scripts/WAN0_ipv6privacy.sh](scripts/WAN0_ipv6privacy.sh) : WAN 側の temporary(6.9)/autoconfprivacy(~6.8) な IPv6 を取得してファイルに書き出すスクリプト
- [scripts/gwi_address.sh](scripts/gwi_address.sh) : IPv6 のアドレスが変わったときに tunnel の設定を変えるスクリプト

## Config
OpenBSD に対応した ND proxy はまだ存在しないようなので、client から IPv6 で通信するのであれば、IPv6-IPv6 NAT になります。また sysctl.conf で `net.inet6.ip6.forwarding=1` で IPv6 packet の転送を許可します。

WAN0 は `inet6 autoconf temporary`(6.9)/`inet6 autoconf autoconfprivacy`(~6.8) で設定します。

LAN1 は IPv4 ルーターのままの設定で、必要があれば IPv6 address 設定してアドレスを rad(8) で配ります。
PPPoE と併用するのであれば、`MTU 1454`/`MSS 1414` になります。DS-Lite のみであれば `MTU 1460`/`MSS 1420` になります。

[scripts/boot_config](scripts/boot_config) は起動時に tunnel interface の設定をするので、rc.local などで実行されるようにしして下さい。

temporary(6.9)/autoconfprivacy(~6.8) で設定された IPv6 は一定時間で無効になるので、新たな IPv6 address が assign されたらそのアドレスを使うように [scripts/gwi_address.sh](scripts/gwi_address.sh) を cron で適当な間隔で実行されるように設定します。

pf.conf に tunnel interface の MSS を `match on gif0 scrub (random-id max-mss 1414)` のように設定します。また、IPv6-IPv6 NAT を使うのであればその設定も必要です。

## FAQ
Q. 通信している最中に gwi_address.sh で tunnel に使う IPv6 アドレス切り替えたらまずくない？

A. 多分アクティブな TCP connection は切れると思います（実験してない）。夜中など使わない時間に設定しておけば良いかと…。
