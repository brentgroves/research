# **[5 Tips to Speed up Your Docker Image Build](https://vsupalov.com/5-tips-to-speed-up-docker-build/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

Are your Docker builds taking forever? Docker can be a valuable part of your tool belt, or a constant source of annoyance.

This article will walk you through frequent sources of slowness when building Docker images for Python projects, and ways how you can avoid or fix them.

Let’s speed up an utterly slow Docker build together using the right high-level approach, easy to implement tricks and brand-new Docker features to speed up your build protect your coding flow from annoying delays.

If you prefer video, check out my PyConline AU 2020 talk “Speeding up Your Docker Image Build” over here.

## Tip 1: Can you avoid building images?

Using Docker doesn’t have to be all-or-nothing. You can choose to use Docker for deployment, building self-contained images to production, but you don’t have to use it in development.

It’s perfectly fine to do either of:

- Skip using Docker in your dev environment, or…
- Only run backing services in containers, or…
- Provide an example dev environment Dockerfile, or…
- Enjoy your completely dockerized dev environment.

If you choose to use Docker for development, keep in mind that there are different styles of workflows. When developing in Docker, it’s better to bind-mount your code into the running container and avoid rebuilds as much as possible. This way, you’ll keep your iteration times short and avoid busy waiting.

## Tip 2: Structure your Dockerfile instructions like an inverted pyramid

Each instruction in your Dockerfile results in an image layer being created. Docker uses layers to reuse work, and save bandwidth. Layers are cached and don’t need to be recomputed if:

- All previous layers are unchanged.
- In case of COPY instructions: the files/folders are unchanged.
- In case of all other instructions: the command text is unchanged.

To make good use of the Docker cache, it’s a good idea to try and put layers where lots of slow work needs to happen, but which change infrequently early in your Dockerfile, and put quickly-changing and fast layers last. The result is like an inverted pyramid.

![p](https://vsupalov.com/images/docker-speedup/pyramid-layers.png)

## Tip 3: Only copy files which are needed for the next step

Imagine we have the following Dockerfile snippet:

```dockerfile
RUN mkdir /code
COPY code code/
RUN pip install code/requirements.txt
```

Every time anything within the code directory changes, the second line would need to run again, and every following line as well.

That’s a pitty, because the third line only depends on one single file from the code directory: requirements.txt. Here’s how we could avoid re-running the install step on every code change:

```dockerfile
RUN mkdir /code
COPY code/requirements.txt code/
RUN pip install code/requirements.txt
COPY code /code
```

Now, the third line would only run if the file in question changes. Dependencies tend to change infrequently, so that’ll shave off a lot of unnecessary effort from the image build.

If you COPYing files, try to do so selectively. Only add the ones to the image which are needed in the next steps. You can add everything else “on top” as in the second example.

## Tip 4: Download less stuff

If your Docker image builds takes a long time downloading dependencies, it’s a good idea to check whether you’re installing more than you need to.

First, check if you might be downloading development dependencies which are not needed in your image at all. You can probably split them out as “development dependencies” in your package-manager of choice and exclude them from the image this way. Time saved!

One more thing to keep in mind, is the default behaviour of your OS-level package manager. For examle, apt which is used on Ubuntu and Debian, installs “recommended” packages by default. Those are packages you don’t specify (or need) explicitly, but which are installed nevertheless because you might want to have them.

You can avoid this, by adding the --no-install-recommends flag like this:

```bash
apt-get install -yqq --no-install-recommends $YOUR_PACKAGES
```

This way, you will only get the packages you asked for and their necessary requirements, reducing the download and installation time while building your Docker image.

## Tip 5: Use BuildKit with the new cache mount feature

BuildKit is pretty cool. It’s a new image build engine, which can be used instead of the default Docker one. If you use it, you get more concurrency and cache efficiency, cool new features and useful UI outputs.

![b](https://vsupalov.com/images/docker-speedup/buildkit.png)

Sample intermediate BuildKit output.

For the sake of faster image builds, the new cache-mount feature can help you to cache downloaded packages inbetween image rebuilds, even if your dependencies change and the layer needs to be rebuilt.

## In Conclusion

I hope you can use those tips to speed up your Docker image build.
