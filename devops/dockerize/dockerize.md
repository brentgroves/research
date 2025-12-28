# # **[Dockerize it](https://blog.codemine.be/posts/20190125-devops-eks-externaldns/)**

**[Current Status](../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research/research_list.md)**\
**[Back Main](../../../../README.md)**

## Dockerize it

The first step is **[dockerize](https://www.docker.com/why-docker)** your application components, so they can be easily deployed on a kubernetes cluster. Let’s take this straightforward tech stack as example: We have an angular front-end, a .NET Core back-end, and Sql Server as database. Since PR environments should be **[cattle](https://medium.com/@Joachim8675309/devops-concepts-pets-vs-cattle-2380b5aab313)**, even the database is dockerized. This results in completely independent environments, where the database can be thrown away after testing is done.

## Dockerize the back-end component

Probably the easiest of the 3 components. We have a .NET Core back-end. For this, we use a multi-stage dockerfile, so that the resulting image only contains the necessary binaries to run.

```dockerfile
# First build step
FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /app
# config here...
RUN dotnet publish -c Release -o deploy -r linux-x64
# Second build step
FROM microsoft/dotnet:2.0-runtime-jessie AS runtime
WORKDIR /app
COPY --from=build <path/to/deploy/folder> ./
ENTRYPOINT ["dotnet", "Api.dll"]
```

## Dockerize the front-end component (SPA)

A little bit more difficult, since Single Page Applications, like Angular, are mostly hosted as static content. This means some variables should be defined at build time, like an api-host for example. See this **[link](https://vsupalov.com/docker-build-pass-environment-variables/)** for more information on how to configure this with docker builds. Knowing these variables in advance imposes some challenges as we will see below.
