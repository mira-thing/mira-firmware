# Thing firmware

Custom firmware for the Spotify Car Thing that runs as a standalone Spotify observer + controller. No companion app required.

Forked from the [usenocturne/nocturne](https://github.com/usenocturne/nocturne) firmware builder, then stripped of the original daemon and rewired around a `go-librespot` observer.

## Flashing

Detailed instructions are in the releases repository.

## Building

You need `curl`, `zip`/`unzip`, `genimage`, `m4`, `xbps-install`, `mkpasswd`, and `patchelf`. `xbps-install` can be installed on any distro from the [Void Linux static binaries](https://docs.voidlinux.org/xbps/troubleshooting/static.html).

> Don't blindly extract `xbps-static` to your rootfs, pin the destination. The following has worked:
>
> ```
> sudo tar --no-overwrite-dir --no-same-owner --no-same-permissions -xvf xbps-static-latest.x86_64-musl.tar.xz -C /
> ```

On non-arm64 hosts, install `qemu-user-static` (with binfmt registered), or run once:

```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Then:

```
just run
```

Outputs land in `output/`. Or use Docker:

```
just docker-run
```

## related projects

- [`thing-ui/`](../thing-ui) - Vite + React UI
- [`thing-daemon/`](../thing-daemon) - daemon
- [`thing-firmware/`](.) - image builder
- [`thing-kernel/`](../thing-kernel) - patched kernel (rotary-encoder fix), GPL-2.0

## Credits

This firmware builder was forked from [usenocturne/nocturne](https://github.com/usenocturne/nocturne)- credit to Brandon Saldan, shadow, Dominic Frye, and bbaovanc for the original work it builds on

Their builder was itself based on:

- [raspi-alpine/builder](https://gitlab.com/raspi-alpine/builder) by Benjamin Böhmke and Duncan Bellamy
- [JoeyEamigh/nixos-superbird](https://github.com/JoeyEamigh/nixos-superbird)
- [bishopdynamics' superbird-tool](https://github.com/bishopdynamics/superbird-tool) and modified [aml-imgpack](https://github.com/bishopdynamics/aml-imgpack)
- [Thing Labs' superbird-tool fork](https://github.com/thinglabsoss/superbird-tool)

The bundled kernel (`resources/kernel/boot_custom.dump`) is built from [`thing-kernel`](../thing-kernel), our fork of Thing Labs' / spsgsb [kernel-common](https://github.com/thinglabsoss) (Amlogic Linux 4.9).

## License

This firmware builder is **Apache 2.0**.

The bundled kernel image is **GPL-2.0** (Linux) — its source and license live in [`thing-kernel`](../thing-kernel), not here.

> "Spotify" and "Car Thing" are trademarks of Spotify AB. This software is not affiliated with or endorsed by Spotify AB.
