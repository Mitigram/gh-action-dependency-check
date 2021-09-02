# Binary Dependency Check

This action will check the presence of a list of binaries to ensure that your
job/workflow will be able to perform all necessary operations. This is
particularily useful for making sure self-hosted runners are populated with the
right set of tools for the job to complete. You will probably want to use this
action in the early steps of your jobs.

The action fails as soon as one of the binaries cannot be found, it will print
out an error message that will be available in the logs.

## Usage

See [action.yml](./action.yml)

### Check a Single Binary

The following checks that `docker` is accessible at the `$PATH`.

```yaml
steps:
- uses: Mitigram/gh-action-dependency-check@main
  with:
    dependency: docker
```

### Check Several Binaries

The following checks that both `docker` and `docker-compose` are accessible at
the `$PATH`.

```yaml
steps:
- uses: Mitigram/gh-action-dependency-check@main
  with:
    dependency: docker docker-compose
```

Instead, you can provide a list of binaries to check by separating them with
line breaks, such as in the following example. This makes dependencies more
visible and YAML files easier to read.

```yaml
steps:
- uses: Mitigram/gh-action-dependency-check@main
  with:
    dependency: |
      docker
      docker-compose
```

### Increased Verbosity

The `options` action input can be used to provide more options to the internal
dependency check implementation. You can use `-v` to increase verbosity, which
will print out the location of each binary that was found accessible at the
`$PATH`.

```yaml
steps:
- uses: Mitigram/gh-action-dependency-check@main
  with:
    dependency: docker
    options: -v
```

## Developer Notes

You can use the testing [workflow.yml](./workflow.yml) in combination with [act]
to manually test this action. Provided [act] is installed, the following
command, run from the root directory, would exercise this action:

```console
act -b -W . -j test
```

Running [act] through [dew] is possible if you do not want to install [act] in
your environment. Just replace `act` with `dew act` in the command above.

  [act]: https://github.com/nektos/act
  [dew]: https://github.com/efrecon/dew
