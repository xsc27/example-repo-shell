[![CI](https://github.com/xsc27/example-repo-shell/actions/workflows/ci.yaml/badge.svg)](https://github.com/xsc27/example-repo-shell/actions/workflows/ci.yaml)

# Makefile Hello World

This is an example of a repository layout for shell scripts and container images.

- Build with [GNU Make](https://www.gnu.org/software/make/)
- Lint with [pre-commit](https://pre-commit.com/)
  - GitHub Actions workflows ([Actionlint](https://github.com/rhysd/actionlint))
  - Dockerfile [Haskell Dockerfile Linter](https://github.com/hadolint/hadolint)
  - Markdown ([Mdformat](https://github.com/executablebooks/mdformat))
  - Conventional Commits ([commitlint](https://commitlint.js.org))
  - Shell scripts ([ShellCheck](https://github.com/koalaman/shellcheck) and [Beautysh](https://github.com/lovesegfault/beautysh))
- Build container images [Docker](https://www.docker.com/)
- Test container images [goss](https://goss.rocks)
- Publish tests result in CI and PR comment
- Run CI platform [GitHub Actions](https://docs.github.com/en/actions)
- Publish documentation to [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages) with [MkDocs](https://www.mkdocs.org/)
- Release via (leave only 1 enabled in the workflow):
  - Merge PR from branch `v*`
  - Push tag `v*`
  - Run manual workflow
  - Push to default branch to generate CalVer

## Usage

### w/o Arguments

```sh
❯ ./prog.sh
Hello World!
```

### w/ Arguments

```sh
❯ ./src/prog.sh you there
Hello you there!
```

## Build

## Artifact

This is a pseudo step for demostration purposes. Here is where binary artifacts would be created.

```
make build
```

## Container Image

Create a [Docker](https://www.docker.com/) container image tagged with the current short sha.

```
make build-container

# Override tag
make build-container CONTAINER='private_registry/my_image:latest'
```

### Documentation

Documentation is built with [MkDocs](https://www.mkdocs.org/) and the [Material](https://squidfunk.github.io/mkdocs-material/) theme.

```
# Compile content
make docs
```

## Tests

### Lint

Linting is performed with [pre-commit](https://pre-commit.com/). [Docker](https://www.docker.com/) and [shellcheck](https://github.com/koalaman/shellcheck) are required.

```
make lint
```

### Unit

The tests leverage the [Bats](https://github.com/bats-core/bats-core) framework.

```
make test
```

### Container

This builds a container image with [Docker](https://www.docker.com/) and validates it with [goss](https://goss.rocks).

By default, the `make` will first look for `goss-linux-amd64` under the current directory.
See the `dgoss` [documentation](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss#installation) for more details.

```
make test-container

# Specify locations of `goss`
make test-container GOSS_FILES_PATH="${HOME}/Downloads/goss-linux-amd64"
```

# License

Copyright 2021 Carlos Meza

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

```
 http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
