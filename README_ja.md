# DS-Lite config with OpenBSD

[English version](README.md)

OpenBSD 6.6 router �� DS-Lite ���g����悤�ɂ���ݒ�iNTT �Ȋ���z��j


## Reference
- [�Ă��낮 : DS-Lite(RFC6333)��MacOS X�ŗ��p����](https://techlog.iij.ad.jp/contents/dslite-macosx)
- [OpenBSD��IPv6 IPoE��ݒ肵���Ƃ��̃���](https://mano.xyz/post/2018-12-02-openbsd-ipv6-ipoe/)
- [OpenBSD HE IPv6 tunnel](https://xw.is/wiki/OpenBSD_HE_IPv6_tunnel) (IPv6 on IPv4)

## Notation

WAN ���� interface �� `WAN0`�ALAN ���� interface �� `LAN1` �ƕ\�L���܂��B�X�N���v�g���܂߂ēK�X�e���̊��ɍ��킹�� `re0` �Ȃǂ̃C���^�[�t�F�[�X���ɒu�������ĉ������B

## Files

- [scripts/boot_config](scripts/boot_config) : �N������ tunnel ��ݒ肷��R�}���h
- [scripts/WAN0_ipv6privacy.sh](scripts/WAN0_ipv6privacy.sh) : WAN ���� autoconfprivacy �� IPv6 ���擾���ăt�@�C���ɏ����o���X�N���v�g
- [scripts/gwi_address.sh](scripts/gwi_address.sh) : IPv6 �̃A�h���X���ς�����Ƃ��� tunnel �̐ݒ��ς���X�N���v�g

## Config
OpenBSD �ɑΉ����� ND proxy �͂܂����݂��Ȃ��悤�Ȃ̂ŁAclient ���� IPv6 �ŒʐM����̂ł���΁AIPv6-IPv6 NAT �ɂȂ�܂��B�܂� sysctl.conf �� `net.inet6.ip6.forwarding=1` �� IPv6 packet �̓]���������܂��B

WAN0 �� `inet6 autoconf autoconfprivacy` �Őݒ肵�܂��B

LAN1 �� IPv4 ���[�^�[�̂܂܂̐ݒ�ŁA�K�v������� IPv6 address �ݒ肵�ăA�h���X�� rad(8) �Ŕz��܂��B
PPPoE �ƕ��p����̂ł���΁A`MTU 1454`/`MSS 1414` �ɂȂ�܂��BDS-Lite �݂̂ł���� `MTU 1460`/`MSS 1420` �ɂȂ�܂��B

[scripts/boot_config](scripts/boot_config) �͋N������ tunnel interface �̐ݒ������̂ŁArc.local �ȂǂŎ��s�����悤�ɂ����ĉ������B

autoconfprivacy �Őݒ肳�ꂽ IPv6 �͈�莞�ԂŖ����ɂȂ�̂ŁA�V���� IPv6 address �� assign ���ꂽ�炻�̃A�h���X���g���悤�� [scripts/gwi_address.sh](scripts/gwi_address.sh) �� cron �œK���ȊԊu�Ŏ��s�����悤�ɐݒ肵�܂��B

pf.conf �� tunnel interface �� MSS �� `match on gif0 scrub (random-id max-mss 1414)` �̂悤�ɐݒ肵�܂��B�܂��AIPv6-IPv6 NAT ���g���̂ł���΂��̐ݒ���K�v�ł��B

## FAQ
Q. �ʐM���Ă���Œ��� gwi_address.sh �� tunnel �Ɏg�� IPv6 �A�h���X�؂�ւ�����܂����Ȃ��H

A. �����A�N�e�B�u�� TCP connection �͐؂��Ǝv���܂��i�������ĂȂ��j�B�钆�Ȃǎg��Ȃ����Ԃɐݒ肵�Ă����Ηǂ����Ɓc�B
