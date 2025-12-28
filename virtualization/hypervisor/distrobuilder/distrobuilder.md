# **[distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/)**

distrobuilder is an image building tool for LXC and Incus.

Its modern design uses pre-built official images whenever available and supports a variety of modifications on the base image. distrobuilder creates LXC or Incus images, or just a plain root file system, from a declarative image definition (in YAML format) that defines the source of the image, its package manager, what packages to install or remove for specific image variants, OS releases and architectures, as well as additional files to generate and arbitrary actions to execute as part of the image build process.

distrobuilder can be used to create custom images that can be used as the base for LXC containers or Incus instances.

distrobuilder is used to build the images on the **[Linux containers image server](https://images.linuxcontainers.org/)**. You can also use it to build images from ISO files that require licenses and therefore cannot be distributed.

## Project and community

distrobuilder is free software and developed under the Apache 2 license. It’s an open source project that warmly welcomes community projects, contributions, suggestions, fixes and constructive feedback.
