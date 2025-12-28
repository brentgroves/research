# **[Using uv in Docker](https://docs.astral.sh/uv/guides/integration/docker/#using-uv-in-docker)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

Getting started
Tip

Check out the **[uv-docker-example](https://github.com/astral-sh/uv-docker-example)** project for an example of best practices when using uv to build an application in Docker.

uv provides both distroless Docker images, which are useful for copying uv binaries into your own image builds, and images derived from popular base images, which are useful for using uv in a container. The distroless images do not contain anything but the uv binaries. In contrast, the derived images include an operating system with uv pre-installed.

As an example, to run uv in a container using a Debian-based image:

`docker run --rm -it ghcr.io/astral-sh/uv:debian uv --help`

Available images
The following distroless images are available:

- ghcr.io/astral-sh/uv:latest
- ghcr.io/astral-sh/uv:{major}.{minor}.{patch}, e.g., ghcr.io/astral-sh/uv:0.6.17
- ghcr.io/astral-sh/uv:{major}.{minor}, e.g., ghcr.io/astral-sh/uv:0.6 (the latest patch version)

And the following derived images are available:

Based on alpine:3.20:
ghcr.io/astral-sh/uv:alpine
ghcr.io/astral-sh/uv:alpine3.20
Based on debian:bookworm-slim:
ghcr.io/astral-sh/uv:debian-slim
ghcr.io/astral-sh/uv:bookworm-slim
Based on buildpack-deps:bookworm:
ghcr.io/astral-sh/uv:debian
ghcr.io/astral-sh/uv:bookworm
Based on python3.x-alpine:
ghcr.io/astral-sh/uv:python3.13-alpine
ghcr.io/astral-sh/uv:python3.12-alpine
ghcr.io/astral-sh/uv:python3.11-alpine
ghcr.io/astral-sh/uv:python3.10-alpine
ghcr.io/astral-sh/uv:python3.9-alpine
ghcr.io/astral-sh/uv:python3.8-alpine
Based on python3.x-bookworm:
ghcr.io/astral-sh/uv:python3.13-bookworm
ghcr.io/astral-sh/uv:python3.12-bookworm
ghcr.io/astral-sh/uv:python3.11-bookworm
ghcr.io/astral-sh/uv:python3.10-bookworm
ghcr.io/astral-sh/uv:python3.9-bookworm
ghcr.io/astral-sh/uv:python3.8-bookworm
Based on python3.x-slim-bookworm:
ghcr.io/astral-sh/uv:python3.13-bookworm-slim
ghcr.io/astral-sh/uv:python3.12-bookworm-slim
ghcr.io/astral-sh/uv:python3.11-bookworm-slim
ghcr.io/astral-sh/uv:python3.10-bookworm-slim
ghcr.io/astral-sh/uv:python3.9-bookworm-slim
ghcr.io/astral-sh/uv:python3.8-bookworm-slim
As with the distroless image, each derived image is published with uv version tags as ghcr.io/astral-sh/uv:{major}.{minor}.{patch}-{base} and ghcr.io/astral-sh/uv:{major}.{minor}-{base}, e.g., ghcr.io/astral-sh/uv:0.6.17-alpine.

For more details, see the **[GitHub Container page](https://github.com/astral-sh/uv/pkgs/container/uv)**.
