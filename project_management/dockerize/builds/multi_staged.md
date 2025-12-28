# **[What's Up With Multi-Stage Builds?](https://vsupalov.com/multi-stage-builds/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

What are multi-stage Docker builds for? What can you do with them, and why should you care?

Here’s a quick explanation of the benefits, without going into too many details!

## You Can Copy Between Stages

This is the most important part to grasp. What makes multi-stage builds useful, is that you can copy specific folders and files from one named stage to another.

This way, you can selectively copy only what you need in your final image from other stages.

## Fewer Layers In Your Final Image

This comes in handy, when producing a final artifact requires lots of busy-work. Think of building an executable, or a minimized css file. You need tools to produce it, you need the source files. But all you need in your final image, is the finished product.

Usually, you’d need to either:

1. make your peace that there’s stuff in your image which is not necessary
2. squash out intermediate layers (bad for image caching)
3. try to do everything in a single instruction (unreadable Dockerfile)

With multi-stage builds, you can have layers in your intermediate images, to **[speed up your Docker image builds](https://vsupalov.com/5-tips-to-speed-up-docker-build/)**. But all the intermediate stuff does not need to end up in your final image.

TAGS: DOCKER BUILD, DOCKER BUILDKIT, DOCKER MULTI STAGE BUILDS
What are multi-stage Docker builds for? What can you do with them, and why should you care?

Here’s a quick explanation of the benefits, without going into too many details!

You Can Copy Between Stages
This is the most important part to grasp. What makes multi-stage builds useful, is that you can copy specific folders and files from one named stage to another.

This way, you can selectively copy only what you need in your final image from other stages.

Fewer Layers In Your Final Image
This comes in handy, when producing a final artifact requires lots of busy-work. Think of building an executable, or a minimized css file. You need tools to produce it, you need the source files. But all you need in your final image, is the finished product.

Usually, you’d need to either:

make your peace that there’s stuff in your image which is not necessary
squash out intermediate layers (bad for image caching)
try to do everything in a single instruction (unreadable Dockerfile)
With multi-stage builds, you can have layers in your intermediate images, to speed up your Docker image builds. But all the intermediate stuff does not need to end up in your final image.

Instead, you can specify:

```dockerfile
FROM (...) AS builder
# steps to build the binary

# the final, unnamed stage
FROM (...)
COPY --from=builder /binary .
```

And only the binary file will be present in the final image

## Less Busywork, Smaller Images, Better-Cached Builds

These are the upsides, that multi-stage builds can give you. In addition, your pushes and pulls will be smaller, as you can make better use of caching layers for your final image as well, apart from the intermediate ones.

If you want to learn more about speeding up your Docker image builds, take a look at **[these tips](https://vsupalov.com/5-tips-to-speed-up-docker-build/)** you can use.
