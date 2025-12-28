# **[model](https://documentation.ubuntu.com/juju/latest/reference/model/index.html)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

In Juju, a model is an abstraction that holds applications and application supporting components – machines, storage, network spaces, relations, etc.

A model is created by a user, and owned in perpetuity by that user (or a new user with the same name), though it may also be used by any other user with model access level, within the limits of their level.

A model is created on a controller. Both the model and the controller are associated with a cloud (and a cloud credential), though they do not both have to be on the same cloud (this is a scenario where you have a ‘multicloud controller’ and where you may have ‘cross-model relations (integrations)’). Any entities added to the model will use resources from that cloud.

One can deploy multiple applications to the same model. Thus, models allow the logical grouping of applications and infrastructure that work together to deliver a service or product. Moreover, one can apply common configurations to a whole model. As such, models allow the low-level storage, compute, network and software components to be reasoned about as a single entity as well.

## Model taxonomy

Models are of two types:

The controller model (controller). This is your Juju management model. A Juju deployment will have just one controller model, which is created by default when you create a controller (juju bootstrap). It typically contains a single machine, for the controller (since Juju 3.0, the controller application). If controller high availability  is enabled, then the controller model would contain multiple instances. The controller model may also contain certain applications which it makes sense to deploy near the controller – e.g., starting with Juju 3.0, the juju-dashboard application.

Regular model. This is your Juju workload model. A Juju deployment may have many different workload models, which you create manually (juju add-model). It is the model where you typically deploy your applications.

Model configuration
A model configuration is a rule or a set of rules that define the behavior of a model – including the controller model.

See more: List of **[model configuration keys](https://documentation.ubuntu.com/juju/latest/reference/configuration/list-of-model-configuration-keys/#list-of-model-configuration-keys)**, Configure a model
