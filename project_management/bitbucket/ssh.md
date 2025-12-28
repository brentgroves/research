# **[Configure SSH and two-step verification](https://support.atlassian.com/bitbucket-cloud/docs/configure-ssh-and-two-step-verification/)**

The third-party Git Credential Manager (GCM) can be used as alternative method of connecting to Bitbucket Cloud from the Git CLI. If you do not want to configure SSH access for your Bitbucket Cloud account, you can download and install the GCM from Git Credential Manager on GitHub. Note that the GCM works over HTTPS, not SSH. Ensure your Git remotes are using HTTPS, such as:
git clone https://{username}@bitbucket.org/{workspace}/{repository}.git

SSH Client Keys
The URL you use to access a repository depends on the connection protocol (HTTPS or SSH) and the distributed version control system. You can find your repository-specific URLs from the repository Source page. The following table shows these URL formats:

## HTTPS

https://<repo_owner>@bitbucket.org/<accountname>/<reponame>.git

## SSH

```bash
# <git@bitbucket.org>:<repo_owner>/<reponame>.git
git clone bitbucket.org:<repo_owner>/<reponame>.git

```

or

ssh://git@bitbucket.org/<repo_owner>/<reponame>.git
