# # **[Pass Docker Environment Variables During The Image Build](https://vsupalov.com/docker-build-pass-environment-variables/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

Working with ENV instructions and environment variables when building Docker images can be surprisingly challenging.

This article is an overview of all the ways you can pass or set variables while building a Docker image, from simple to more complex.

## Option 1: Hardcoding Default ENV values

Fixed ENV values can be good enough in some cases, and the easiest way to define a variable which is usable during your image build as well as by a future container started from that image. You can specify a default value (some_value in the example below) right next to your variable definition in the Dockerfile:

```dockerfile
ENV env_var_name=some_value
```

If your variable values won’t change frequently in the future, you can use this method to configure sane defaults for your future containers. But what if you need to change those values every once and again without changing your Dockerfile?

Let’s look at a way to set dynamic ENV values during the build, directly from your command line.

## Intermission: ARG vs ENV

To set environment variables during your image build, you will need either ENV or ARG and ENV at the same time.

Docker ENV and ARG are pretty similar, but not quite the same. Here are the main differences:

- ARG can be set during the image build with --build-arg.
- ARG are only accessible DURING an image build, not in the future container.
- You can’t set an ENV value directly.

The command made up of ENTRYPOINT and CMD, which runs inside the future containers, can’t access ARG values.

While ENV values are accessible during the build, and once the container runs, you can’t set them directly. Here is how you can bridge the gap:

## Option 2: Setting Dynamic ENV Values

Hardcoded ENV values can be a tedious solution if they need to be changed often. Imagine having to edit your Dockerfile again and again with each build.

You can do better! Introduce a new ARG variable, and use the ARG variable to set your ENV variable value dynamically during the build. Here is how that can look inside your Dockerfile:

```dockerfile
ARG var_name
# you could give this a default value as well like this:
# ARG var_name=something_default

# in any case, we use the ARG value here:
ENV env_var_name=$var_name
```

the “env_var_name” environment variable value will be set to the value of var_name. This way, you will have an environment variable available to future containers, set during the build via ARG variable.

You can override that value as well: If needed, you can define another value for env_var_name when starting up a container from the image. Dockerfile values are not set in stone. They are just default values.

## Option 2.5: Using Host Environment Variable Values to Set ARGs

What if you want to set the ARG value based on an environment variable in your current shell environment, without having to type it out each time? You can pass the value directly from your command line into the Docker build using bash command substitution. Here is how a docker build command could look like:

```bash
docker build --build-arg var_name=${VARIABLE_NAME} (... rest of command)
```

The dollar-notation will be substituted with the value of the current environment variable. This sets the ARG var_name.

Alternatively, you can pass the value from the environment automatically without a substitution, if your variable in the Dockerfile is named the same as the env var in question. Just don’t mention the value, and let Docker look it up:

```bash
docker build --build-arg var_name (... rest of command)
```

## Gotchas You Should Keep In Mind

ARG and ENV values are not suitable to handle secrets without extra care. The stick around in your final images.

Note: well, unless you squash your layers, or use careful multi-stage builds.

ARG values, both dynamic and hard-coded, can be looked at by other people after the image is built. You can give it a try, with the docker history command on your own image. ENV values can be discovered in many ways, from within the container if they were not overwritten, with the inspect command or from the history as well if they were hard-coded.

To avoid leaking your secrets in various ways, check out **[multi-stage builds](https://vsupalov.com/multi-stage-builds/)** or some of these **[shiny new BuildKit features](https://vsupalov.com/better-docker-private-git-ssh/)**.

## That’s It

I hope that this overview was helpful, and the information will make it easier to set Docker environment variables during the your Docker image build stage. Go ahead and set ARG values, and maybe some ENV as well.

Once again, remember to be cautious when considering ARG and ENV for secrets, as they are not safe. Consider looking into **[multi-stage builds](https://vsupalov.com/multi-stage-builds/)** or using BuildKit to **[handle build-time secrets](https://vsupalov.com/better-docker-build-secrets/)** instead.

If you want to get a good overview of build-time arguments, environment variables, env_files and docker-compose templating with .env files - head over to this in-depth guide about ENV and ARG variables in Docker. Building an in-depth understanding of this topic is the best way to stop struggling and get back to what you actually want to achieve.
