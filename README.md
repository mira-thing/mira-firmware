# Mira firmware

Mira firmware builder for the Spotify Car Thing.

Part of [Mira](https://github.com/mira-thing)

## Flashing

Prebuilt images and step-by-step flashing instructions live in [mira-releases](https://github.com/mira-thing/mira-releases).

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

## Support

Mira is free and open source. If you'd like to support development, you can do so on [GitHub Sponsors](https://github.com/sponsors/MustakimK) or [Ko-fi](https://ko-fi.com/MustakimK). Questions and updates are on [Discord](https://discord.gg/SR2Pne7EPM).

## Related projects

- [`mira-ui`](https://github.com/mira-thing/mira-ui) - Vite + React UI
- [`mira-daemon`](https://github.com/mira-thing/mira-daemon) - daemon
- [`mira-voice`](https://github.com/mira-thing/mira-voice) - on-device voice stack
- [`mira-releases`](https://github.com/mira-thing/mira-releases) - prebuilt firmware images
- [`mira-firmware`](.) - image builder (this repo)

## Attributions

This firmware builder was forked from [usenocturne/nocturne](https://github.com/usenocturne/nocturne) - credit to Brandon Saldan, shadow, Dominic Frye, and bbaovanc for the original work it builds on

Their builder was itself based on:

- [raspi-alpine/builder](https://gitlab.com/raspi-alpine/builder) by Benjamin Böhmke and Duncan Bellamy
- [JoeyEamigh/nixos-superbird](https://github.com/JoeyEamigh/nixos-superbird)
- [bishopdynamics' superbird-tool](https://github.com/bishopdynamics/superbird-tool) and modified [aml-imgpack](https://github.com/bishopdynamics/aml-imgpack)
- [Thing Labs' superbird-tool fork](https://github.com/thinglabsoss/superbird-tool)

The bundled kernel (`resources/kernel/boot_custom.dump`) is a patched fork of Thing Labs'/spsgsb [kernel-common](https://github.com/thinglabsoss).

## License

This firmware builder is **Apache 2.0**.

The bundled kernel image is **GPL-2.0** (Linux), a patched fork of Thing Labs'/spsgsb kernel-common. The complete corresponding source is available to any third party on request for at least three years from distribution; open an issue on this repo or ask on [Discord](https://discord.gg/SR2Pne7EPM).

> "Spotify" and "Car Thing" are trademarks of Spotify AB. This software is not affiliated with or endorsed by Spotify AB.
