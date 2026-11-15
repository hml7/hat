# hat

A recreational programming project that reimplements *cat(1)* in [Hare](https://harelang.org). Heavily inspired by [sharkdp's bat](https://github.com/sharkdp/bat).

> [!WARNING]
> hat is developed purely as a recreational project, so it takes its own approach rather than aiming to be a full `cat` replacement. Think of it as a prettier `cat` experience, not a drop-in replacement. It is still under development.
>
> Long term, the goal is to support POSIX `cat` behavior, but that is not the case yet.

## Installation

### From source

To build `hat` from source, you need:

- [Hare](https://harelang.org) and its dependencies (such as [qbe](https://c9x.me/compile/))
- [scdoc](https://git.sr.ht/~sircmpwn/scdoc), only if you want the man page
- `make`
- `git`, optional: the build uses it to derive the version number, and falls back to `dev` without it

Then build and install:

```sh
git clone https://github.com/hml7/hat.git hat
cd hat
make
sudo make install
```

To install without root, point `PREFIX` at your home directory:

```sh
make install PREFIX=$HOME/.local
```

Make sure `~/.local/bin` is on your `PATH`. Use the same `PREFIX` when uninstalling:

```sh
sudo make uninstall
```
