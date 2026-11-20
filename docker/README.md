# Free Pascal in Docker (Debian)

A small Docker image with the [Free Pascal](https://www.freepascal.org/) compiler, based on `debian:stable-slim`. It is meant for machines without a native fpc, such as a Synology NAS (e.g. DS718+), but works on any Docker host.

The image contains:
- `fpc` from the Debian repositories (Free Pascal 3.2.2), including the standard units and the `ld` linker
- the `nl_NL.UTF-8` and `en_US.UTF-8` locales, so programs using the `clocale` unit (like `DaysUntil.pas`) get the right date format
- the default settings `LANG=nl_NL.UTF-8` and `TZ=Europe/Amsterdam`

Debian is used because `apt-get install fpc` installs everything in one go, and because it uses glibc, like DSM. That means a program compiled in the container also runs directly on the NAS. Alpine uses musl, so its binaries may not run on DSM.

## Setup on a Synology NAS

1. **Install Container Manager** from Package Center (on DSM 6 this package is called *Docker*).
2. **Enable SSH**: *Control Panel → Terminal & SNMP → Enable SSH service*.
3. **Copy this repository** to the NAS, e.g. to `/volume1/scripts/pascal` (via File Station, `scp`, or `git clone`).
4. **Log in and build the image**:
   ```bash
   ssh <user>@<nas-ip>
   cd /volume1/scripts/pascal
   sudo docker build -t fpc docker/
   ```
   The build takes a few minutes and only has to be done once. The image then also shows up in Container Manager under *Image*.

On DSM, `docker` must be run with `sudo`. On a Mac or Linux machine where your user is in the `docker` group, leave out the `sudo`.

## Usage

Compile a program in the current folder. The binary is written next to the source file:

```bash
sudo docker run --rm -v "$PWD":/src fpc fpc DaysUntil.pas
./DaysUntil 25-12-2026
```

- `--rm` removes the container after use
- `-v "$PWD":/src` makes the current folder available as `/src` (the working directory in the container)

Run the program inside the container instead of on the host:

```bash
sudo docker run --rm -it -v "$PWD":/src fpc ./DaysUntil
```

Use a different locale or time zone:

```bash
sudo docker run --rm -v "$PWD":/src -e LANG=en_US.UTF-8 -e TZ=UTC fpc ./DaysUntil 2026-12-25
```

Open an interactive shell with fpc available:

```bash
sudo docker run --rm -it -v "$PWD":/src fpc
```

### Handy alias

Add this to `~/.profile` on the NAS so `fpc` works as if it were installed natively:

```bash
alias fpc='sudo docker run --rm -v "$PWD":/src fpc fpc'
```

Then just run `fpc DaysUntil.pas`.

### Task Scheduler

To run a compiled program on a schedule, add a *User-defined script* task in *Control Panel → Task Scheduler*:

```bash
/volume1/scripts/pascal/DaysUntil 25-12-2026
```

No container is needed for this, because the binary runs directly on DSM.

## Updating

Rebuild the image to get the latest Debian and fpc updates:

```bash
sudo docker build --pull --no-cache -t fpc docker/
```

## Note on CPU architecture

The image is built for the CPU of the machine it is built on. The DS718+ has an Intel CPU (x86_64), so build the image on the NAS itself. An image built on an Apple Silicon Mac is arm64, and so are the binaries it compiles, which won't run on the NAS. To build an x86_64 image on a Mac anyway, use `docker build --platform linux/amd64 -t fpc docker/`.
