# Pascal
Small Pascal training programms, the language I used a long time ago on different computers/infra-structures.

## Programs

| File | Description |
| --- | --- |
| `HelloWorld.pas` | Asks for your name and greets you, then demonstrates a `for`-loop counting from 1 to 10. |
| `Loops.pas` | Demonstrates a `for`-loop that sums 1 to 10, and a `while`-loop that counts down from 20 by subtracting 2. |
| `LoopsFunction.pas` | Same `for`/`while` loop demo as `Loops.pas`, but each loop is wrapped in its own function (`SumWithForLoop`, `CountDownWithWhileLoop`). |
| `DaysUntil.pas` | Calculates the number of days and nights from today to a given date, passed as an argument or typed in. The date can be entered in the computer's locale format (e.g. `25-12-2026` for Dutch, via the `clocale` unit) or as ISO `YYYY-MM-DD`. Also shows the days including both ends and the number of weeks. Uses the `SysUtils` and `DateUtils` units. |

## Shell script (NixOS)

As I'm currently using NixOS Linux on most of my computers, I needed a quick way to use [Free Pascal](https://www.freepascal.org/). 
`startpascal.sh` opens a [Nix shell](https://nixos.org/manual/nix/stable/command-ref/nix-shell.html) with the Free Pascal compiler, Lazarus IDE, and GDB debugger available, without installing them system-wide. Run it with:

```bash
./startpascal.sh
```

Once inside the shell, you can:
- Compile a program: `fpc <file.pas>`
- Open the Lazarus GUI: `startlazarus`

## Installing Free Pascal on macOS (Apple Silicon)

On a Mac (e.g. MacBook Pro M1) Free Pascal can be installed with [Homebrew](https://brew.sh/):

```bash
xcode-select --install   # Apple command line tools (linker)
brew install fpc
fpc -i                   # check the installation
```

Compile and run a program:

```bash
fpc DaysUntil.pas
./DaysUntil 25-12-2026
```

If linking fails (e.g. `library not found for -lc`), point fpc to the macOS SDK:

```bash
fpc -XR$(xcrun --show-sdk-path) DaysUntil.pas
```

Optionally, the Lazarus IDE can be installed with `brew install --cask lazarus`.

## Syntax highlighting in nano

`pascal.nanorc` adds Pascal syntax highlighting to [GNU nano](https://www.nano-editor.org/) (keywords, types, built-in routines, numbers, strings, compiler directives and `//`, `{ }`, `(* *)` comments). Keywords are matched case-insensitively, and it applies to `.pas`, `.pp`, `.p`, `.inc`, `.lpr` and `.dpr` files.

Install it by copying the file and including it in your `~/.nanorc`:

```bash
mkdir -p ~/.nano
cp pascal.nanorc ~/.nano/
echo 'include "~/.nano/pascal.nanorc"' >> ~/.nanorc
```

Then open a Pascal file, e.g. `nano DaysUntil.pas`. This needs GNU nano: on macOS the built-in `/usr/bin/nano` is actually `pico`, so install GNU nano with `brew install nano` first.
