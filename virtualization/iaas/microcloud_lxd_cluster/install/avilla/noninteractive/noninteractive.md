# **[Non-interactive configuration](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/initialize/#non-interactive-configuration)**

If you want to automate the initialization process, you can provide a preseed configuration in YAML format to the microcloud preseed command:

cat <preseed_file> | microcloud preseed
Make sure to distribute and run the same preseed configuration on all systems that should be part of the MicroCloud.

The preseed YAML file must use the following syntax:
