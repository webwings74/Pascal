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

## Terminal workflow, step by step

The complete flow from your own computer (Mac or Linux) to a compiled program on the NAS, using only the terminal. Replace `<user>` and `<nas-ip>` with your DSM user name and the IP address or host name of the NAS.

### 1. Copy the repository to the NAS (on your computer)

```bash
cd ~/Code
ssh <user>@<nas-ip> "mkdir -p /volume1/scripts/pascal"
scp -O -r Pascal/*.pas Pascal/docker <user>@<nas-ip>:/volume1/scripts/pascal/
```

The `-O` flag uses the classic scp protocol, which DSM's SSH server needs with recent OpenSSH clients. Alternatively, if the *Git Server* package is installed on the NAS, use `git clone` on the NAS itself.

### 2. Log in to the NAS

```bash
ssh <user>@<nas-ip>
cd /volume1/scripts/pascal
```

### 3. Check that Docker works

```bash
sudo docker version
```

This should show both a *Client* and a *Server* part. If you get `command not found`, use the full path `/usr/local/bin/docker`. If the *Server* part is missing, Container Manager is not running: start it in Package Center.

### 4. Build the image (once)

```bash
sudo docker build -t fpc docker/
sudo docker images fpc          # check: shows the 'fpc' image
sudo docker run --rm fpc fpc -iV   # check: prints the fpc version, e.g. 3.2.2
```

### 5. Compile a program

```bash
sudo docker run --rm --user "$(id -u):$(id -g)" -v "$PWD":/src fpc fpc DaysUntil.pas
```

`--user "$(id -u):$(id -g)"` runs the compiler as your own DSM user. Without it, the binary and the `.o` files are owned by `root` and you can't remove or overwrite them without `sudo`.

### 6. Run the program

Directly on DSM:

```bash
./DaysUntil 25-12-2026
```

Or inside the container (with the container's locale and time zone):

```bash
sudo docker run --rm -it -v "$PWD":/src fpc ./DaysUntil
```

### 7. Edit, compile, run again

Edit the source on the NAS (`vi DaysUntil.pas`), or edit it on your computer and copy it again with `scp`. Then repeat steps 5 and 6. The image doesn't need to be rebuilt.

### 8. Clean up (optional)

```bash
rm -f *.o                       # remove object files
sudo docker rmi fpc             # remove the image if you no longer need it
```

### Troubleshooting

| Problem | Solution |
| --- | --- |
| `permission denied ... docker.sock` | Run `docker` with `sudo`. |
| `sudo: docker: command not found` | Use `sudo /usr/local/bin/docker ...`. |
| `Operation not permitted` when removing files | Files were created as root; remove with `sudo rm`, and use `--user` from step 5. |
| `cannot execute binary file` | The binary was compiled for another CPU (e.g. on an M1 Mac); compile it on the NAS. |
| `scp: Connection closed` | Add `-O` to the `scp` command, or enable SFTP in *Control Panel → File Services → FTP → SFTP*. |
| Wrong date format | Check `echo $LANG`; pass a locale with `-e LANG=nl_NL.UTF-8` when running in the container. |

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
alias fpc='sudo docker run --rm --user "$(id -u):$(id -g)" -v "$PWD":/src fpc fpc'
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
