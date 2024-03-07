<div align="center">

# asdf-ruff [![Build](https://github.com/simhem/asdf-ruff/actions/workflows/build.yml/badge.svg)](https://github.com/simhem/asdf-ruff/actions/workflows/build.yml) [![Lint](https://github.com/simhem/asdf-ruff/actions/workflows/lint.yml/badge.svg)](https://github.com/simhem/asdf-ruff/actions/workflows/lint.yml)

[ruff](https://docs.astral.sh/ruff/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add ruff
# or
asdf plugin add ruff https://github.com/simhem/asdf-ruff.git
```

ruff:

```shell
# Show all installable versions
asdf list-all ruff

# Install specific version
asdf install ruff latest

# Set a version globally (on your ~/.tool-versions file)
asdf global ruff latest

# Now ruff commands are available
ruff --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/simhem/asdf-ruff/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Simon](https://github.com/simhem/)
