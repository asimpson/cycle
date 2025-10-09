---
title: "Windows 11 as KVM guest"
date: 2022-02-28T13:39:37-0500
lastmod: 2022-02-28T13:39:37-0500
slug: windows-11-as-kvm-guest
excerpt: "How I work with Windows 11 as a KVM guest on a NixOS host using virt-manager."
---

Windows 11 famously has new, stricter [requirements for installation](https://www.microsoft.com/en-us/windows/windows-11-specifications); a TPM device and Secure Boot. Here's how I satisfied those requirements with Windows 11 as a KVM guest with NixOS as the host. The following is pulled from my [NixOS `configuration.nix`](https://github.com/asimpson/dotfiles/commit/ab08fd88a5617d9199f78726c1f22f32b8fc85d0):

```nix
libvirtd.qemu = {
  package = pkgs.qemu_kvm;
  runAsRoot = true;
  swtpm.enable = true;
  ovmf = {
    enable = true;
    package = (pkgs.OVMFFull.override {
      secureBoot = true;
      tpmSupport = true;
    });
  };
};
```

The most important bit is the `pkgs.OVMFFull.override` section where you must specify `tpmSupport` and `secureBoot` as `true`.

In [virt-manager](https://virt-manager.org/) you'll need to add "new hardware" and select TPM v2.0. Here's the relevant XML from my config:

```xml
<tpm model="tpm-crb">
  <backend type="emulator" version="2.0"/>
</tpm>
```

With the above settings you should be able to go through the Windows 11 installer and get the machine up and running as a KVM guest.

## Stretch goal: nested virtualization
If you want to use Docker or WSL 2 inside KVM you'll need to enable "nested virtualization" in virt-manager. I couldn't figure this out until I found [this great answer on superuser](https://superuser.com/a/1589286).

My original CPU config XML looked like this:

```xml
<cpu mode="host-model" check="partial">
  <topology sockets="1" dies="1" cores="2" threads="4"/>
</cpu>
```

The new XML looks like this:

```xml
<cpu mode="custom" match="exact" check="partial">
  <model fallback="allow">Skylake-Client-noTSX-IBRS</model>
  <topology sockets="1" dies="1" cores="2" threads="4"/>
  <feature policy="disable" name="hypervisor"/>
  <feature policy="require" name="vmx"/>
</cpu>
```

With this applied I could install WSL2 _and_ get Docker Desktop for Windows installed and running.
