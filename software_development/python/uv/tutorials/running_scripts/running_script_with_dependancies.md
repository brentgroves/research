# **[Running a script with dependencies](hhttps://docs.astral.sh/uv/guides/scripts/#running-a-script-without-dependencies)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

When your script requires other packages, they must be installed into the environment that the script runs in. uv prefers to create these environments on-demand instead of using a long-lived virtual environment with manually managed dependencies. This requires explicit declaration of dependencies that are required for the script. Generally, it's recommended to use a **[project](https://docs.astral.sh/uv/guides/projects/)** or **[inline metadata](https://docs.astral.sh/uv/guides/scripts/#declaring-script-dependencies)** to declare dependencies, but uv supports requesting dependencies per invocation as well.
