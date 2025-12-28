# **[Model Driven Operator](https://juju.is/model-driven-operations-manifesto)**

The Model Driven Operator Manifesto
Better operators through open community standards
Our goal is to improve devsecops with open source operators for widely used software. These shared values ensure high quality code and conversations.

Source required
We make operator source available so that everybody can understand exactly what happens on their systems.

Open source preferred
We are an open source community to enable everyone to contribute to common app operations. Our frameworks and tools are open source, but our framework license does allow vendors to create interoperable operators with their own license.

Community-driven
An operator distills real-world application experience into shared code. No one person can know all the ways an app will be used. Open community discussions and code are the best way to improve operator performance, usability, quality and completeness.

Security
An operator should apply defense-in-depth to every aspect of operations — from data encryption and app confinement to password selection and key handling. We review all operators for security, and we publish fixes fast.

Multi-cloud optimisation
An operator should work on every cloud or Kubernetes, and should also automatically optimise for its environment and take advantage of local, differentiated capabilities.

Reusability
Reuse improves quality and grows the community. An operator should offer many ways to deploy the application — large or small scale, resilient or minimal, persistent or ephemeral, standalone or integrated with as many other apps as possible.

Patches
Operators should facilitate security patching, to help administrators maintain a healthy and compliant deployment. High-quality updates are essential for security.

Upgradability
Operators should manage upgrades. An operator should ensure maximum availability throughout the upgrade and provide a way to roll back to prior state.

High-level config
Operators should abstract complex application configuration. An operator should offer only high-level config to capture admin intent and reduce the burden of application specific domain expertise required to run the app.

Scalability
Applications are often clustered for resilience or performance. An operator should handle dynamic changes, optimise for admin intent, and scale up or down equally well.

Everyday actions included
Daily actions like backup, restore, reset, and restart should never require direct admin access to underlying systems or containers. Actions should be driven by API or CLI, subject to permissions, and logged for audit and accountability.

Status
Admins should never require direct access to underlying systems or containers to know the status of a workload. An operator should assess and represent the health, availability, and dependencies of the app.

Leadership
In distributed systems, problems occur if different units of the same app make conflicting decisions. An operator should provide leadership and communicate leader decisions to all units in a reliable way with proven consistency.

Subordinate software
An operator should provide for related functions to coexist in its execution environment, whether that is a Kubernetes pod or a machine.

Application graph
Most of the work in enterprise software operations is integration. An operator should go beyond the application lifecycle to the application graph, and enable integration with as many other applications as possible to support as many scenarios as possible.

Interoperability
Enterprises require multi-vendor deployments to work well. Operators should work well with operators from other vendors and publishers. Collaboration is best done in a public forum to ensure the widest participation.

Consistency
It is easier to use new applications if they follow common patterns. An operator should use common conventions to simplify the learning and adoption curve.

Substitution
Enterprises expect to choose the actual implementation of services in a deployment. Operators should not assume specific integration counterparts, to allow substitution with compatible alternatives.

Model-driven
Applications must work together to be successful. Operators should respond to changes in a shared model that describes the whole application graph and config.

Capacity agnostic
Admins may deploy the application on a few small machines, or many large machines. An operator should not assume capacity or scale, but learn it from the model.

Network Agnostic
Different scenarios require different networking for the same application. An operator should support segregated network architecture as described in the model.

Cross platform
Enterprises have applications on both Windows and Linux, and many deployments integrate platforms. The ops library should enable multi-platform scenarios.

Multi-arch
An operator should work on all supported architectures of the application.

Tested
Operators are privileged software dealing with critical apps in sensitive environments. An operator should have both unit and integration tests that gate all changes.

Trusted builds
An operator should be built in a trusted environment, just like the app it drives, to guarantee provenance and integrity.

Signed
Operators are privileged software in which users place great trust. An operator should be signed to know who produced it, and prove that it has not been modified.

Beta testing
An operator should publish beta and release candidate versions to enable widespread testing and increase the quality of stable releases.

Managed
An enterprise environment must plan changes. Operators should enable fine-grained control of updates and enterprise control of application versions.

Operators that embrace these principles, practices and values are better for a wider audience. We elevate the art of application management with universal, open operators that reflect the deepest insights from the broadest community in the widest contexts.
