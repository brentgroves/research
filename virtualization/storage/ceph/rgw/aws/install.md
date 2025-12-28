# **[ubuntu aws](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)**

The AWS Command Line Interface (CLI) is a unified tool to manage your AWS services. With just one tool to download and configure, you can control multiple AWS services from the command line and automate them through scripts.

We provide an official AWS supported version of the AWS CLI on snap. If you want to always have the latest version of the AWS CLI installed on your system, a snap package provides this for you as it auto-updates. There is no built-in support for selecting minor versions of AWS CLI and therefore it is not an optimal install method if your team needs to pin versions. If you want to install a specific minor version of the AWS CLI, we suggest you use the command line installer.

Run the following snap install command for the AWS CLI.

```bash
sudo snap install aws-cli --classic
aws-cli (v2/stable) 2.27.53 from Amazon Web Services (aws✓) installed
```
