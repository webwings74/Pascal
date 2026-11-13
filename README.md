# Pascal
Small Pascal training programms, the language I used a long time ago on different computers/infra-structures.

## Programs

| File | Description |
| --- | --- |
| `HelloWorld.pas` | Asks for your name and greets you, then demonstrates a `for`-loop counting from 1 to 10. |

## Shell script (NixOS)

As I'm currently using NixOS Linux on most of my computers, I needed a quick way to use [Free Pascal](https://www.freepascal.org/). 
`startpascal.sh` opens a [Nix shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html) with the Free Pascal compiler, Lazarus IDE, and GDB debugger available, without installing them system-wide. Run it with:

```bash
./startpascal.sh
```

Once inside the shell, you can:
- Compile a program: `fpc <file.pas>`
- Open the Lazarus GUI: `startlazarus`
