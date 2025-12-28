# **[Test environments with Azure DevOps, EKS and ExternalDNS](https://blog.codemine.be/posts/20190125-devops-eks-externaldns/)**

**[Current Status](../../../development/status/weekly/current_status.md)**\
**[Research List](../../../research/research_list.md)**\
**[Back Main](../../../README.md)**

## The problem

Our current Software Development lifecycle at work is straightforward: We have a development, a staging, and a production environment. We use feature-branches and pull-request where developers review each other PR’s before it gets merged (and auto-deployed) into development. On development, it gets tested by test-team. And once approved, gets pull-requested and accepted to the staging environment, where business can test it as well before going to production.

![sdl](https://blog.codemine.be/20190125-devops-eks-externaldns/current.jpeg)

All is fine, except that if test-team disapproves a certain feature, then development is in a kind of blocked state, containing both features who have passed by test-team, together with features who are disapproved by test-team. We cannot decide that “feature A and B can go to staging now, but feature C cannot”, since all three features are already on a single branch (dev-branch).

We could try to use something like git cherry-pick but we rather not starting to mess with git branches. Besides, the underlying problem is that test-team should be able to test these features independent of each other. A more ideal solution would be to have separate deployment environments for feature-testing. And so the following idea emerged:

![ti](https://blog.codemine.be/20190125-devops-eks-externaldns/proposed.jpeg)

## The Objective

For provisioning environments for deploying PR’s, different options exists. Whatever option is chosen, it is important to follow the concept of cattle, not pets, resulting in that these environments should be easy to set up, and also easy to break down or replace. We chose to use Kubernetes for this situation.

Since we are already using Azure DevOps (formally know as Visual Studio Team Services — VSTS), this platform will connect the dots and give us centralised control over the processes. The plan can be summarised as follows:

![obj](https://blog.codemine.be/20190125-devops-eks-externaldns/ci_cd_cycle.jpeg)

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

## Dockerize Sql Server

Sql Server already has **[official docker images](https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017)** that you can use. However, what we would like to do, is make sure that every time a new environment is setup, the database is pre-populated with a dataset of our choice. This would allow us for more efficient testing. To achieve this, we can extend the current (sql-server) docker image with backups, and package the result as a new docker image! More details on how to achieve this can be found in this gist. Your dockerfile will look something like this:

```dockerfile
FROM microsoft/mssql-server-linux 
COPY . /usr/src/app
ENTRYPOINT [ "/bin/bash", "/usr/src/app/docker-entrypoint.sh" ]
CMD [ "/opt/mssql/bin/sqlservr", "--accept-eula" ]
```
