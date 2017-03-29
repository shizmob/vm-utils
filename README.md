# vm-utils

Scripts to manage QEMU-based VMs.

## Why?

I didn't like libvirt.

## Installation

Copy the `vm` folder to your `/etc`, or elsewhere and adjust the `rootdir=` statements in the `scripts/` files.
Optionally, make symlinks for `vm-<script>` to `/etc/vm/scripts/<script>` in your `/usr/local/bin`.
You're gonna want to have `tmux` and `qemu-system-x86_64` installed, as well as KVM (`CONFIG_KVM`) and macvtap (`CONFIG_MACVLAN`) support in your kernel.

## Setup

These scripts presumes a setup like Online.net, where IPv4s are directly routed to your machine and a macvtap interface can accept them,
while an IPv6 prefix is delegated to your machine and you have to explicitly route it through a normal tap interface - hence the dual NICs in the VMs.

## Overview

* `machines.d`: Main VM configurations for QEMU;
* `conf`: VM configurations for `vm-utils`;
* `include`: Include files for VM configurations;
* `scripts`: Various scripts to automate VM management:
  - `start`: Start a VM named by `machines.d/<name>.conf`;
  - `stop`: Stop a VM named by `machines.d/<name>conf`;
  - `attach`: Attach to management console of VM named by `machines.d/<name.conf>`;
  - `launch`: Launch VM in current terminal session and attach to management console; used by `start`
  - `ifup`/`ifup6`/`ifdown`: Network interface management scripts;

## License

WTFPL; see `LICENSE` for details.
