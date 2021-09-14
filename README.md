<div align="center">

# asdf-tokei [![Build](https://github.com/gasuketsu/asdf-tokei/actions/workflows/build.yml/badge.svg)](https://github.com/gasuketsu/asdf-tokei/actions/workflows/build.yml) [![Lint](https://github.com/gasuketsu/asdf-tokei/actions/workflows/lint.yml/badge.svg)](https://github.com/gasuketsu/asdf-tokei/actions/workflows/lint.yml)


[tokei](https://github.com/XAMPPRocky/tokei) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add tokei
# or
asdf plugin add tokei https://github.com/gasuketsu/asdf-tokei.git
```

tokei:

```shell
# Show all installable versions
asdf list-all tokei

# Install specific version
asdf install tokei latest

# Set a version globally (on your ~/.tool-versions file)
asdf global tokei latest

# Now tokei commands are available
tokei --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/gasuketsu/asdf-tokei/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [HARADA Tomoyuki](https://github.com/gasuketsu/)
