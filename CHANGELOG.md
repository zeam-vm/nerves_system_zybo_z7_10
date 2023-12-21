# Changelog

This project does NOT follow semantic versioning. The version increases as
follows:

1. Major version updates are breaking updates to the build infrastructure.
   These should be very rare.
2. Minor version updates are made for every major Buildroot release. This
   may also include Erlang/OTP and Linux kernel updates. These are made four
   times a year shortly after the Buildroot releases.
3. Patch version updates are made for Buildroot minor releases, Erlang/OTP
   releases, and Linux kernel updates. They're also made to fix bugs and add
   features to the build infrastructure.

## v0.0.2

This is a major Buildroot and toolchain update.

* Updated dependencies
  * [nerves_system_br v1.25.2](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.25.2)
  * [Erlang/OTP 26.1.2](https://erlang.org/download/OTP-26.1.2.README)
  * [Buildroot 2023.08.4](https://lore.kernel.org/buildroot/87o7f6t7fs.fsf@48ers.dk/T/)

## v0.0.1

* Dependencies
  * [nerves_system_br v1.24.1](https://github.com/nerves-project/nerves_system_br/releases/tag/v1.24.1)
  * [Erlang/OTP 26.1.1](https://erlang.org/download/OTP-26.1.1.README)
  * [Buildroot 2023.05.3](https://lore.kernel.org/buildroot/87h6ngup34.fsf@48ers.dk/T/)

### This system uses followings,

* https://github.com/Digilent/linux-digilent 's digilent_rebase_v5.15_LTS_2022.1 branch for Linux kernel.
* https://github.com/Digilent/u-boot-digilent 's digilent_rebase_v2022.01 branch for U-boot.

To pin the sources, we download the tarballs from a specific commit on the branch.
