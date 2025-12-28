# **[BuildKit Features You Might Want to Know About](https://vsupalov.com/docker-buildkit-features/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

Accessing private Git repositories during a Docker build, handling secrets and re-downloading lots of dependencies.

If you have struggled with these topics, BuildKit could help you solve them in a more elegant fashion.

I’d like to introduce some of those new features to you, and give a quick impression how they can be used to improve your existing workflows. If you want to see all of them in the docs, check out this docs file from **[BuildKit’s GitHub repo](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md)**.

How to BuildKit
BuildKit was shipped with the Docker Engine since 18.06.

It’s an alternative build engine, built to be more performant than the default build engine. It provides some new features as well.

To use BuildKit, you have to enable it. This can be done by setting an environment variable:

```bash
export DOCKER_BUILDKIT=1
```

Alternatively, you could build your images using docker buildx build instead of docker build as well.

If you’re running Docker 18.06, you’ll have to enable experimental mode for the Docker daemon.
