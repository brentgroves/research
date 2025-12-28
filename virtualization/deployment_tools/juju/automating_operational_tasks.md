# **[Automating Operational Tasks](https://www.innablr.com.au/blog/automating-operational-tasks-with-kubernetes-operator-part-2#:~:text=Remarks-,Juju,identity%2C%20and%20a%20lot%20more.)**

Automating operational tasks with Kubernetes operator - Part 2
Oct 11, 2021
6 min read
In the first blog of this series, we took a looked at what Operator means in the Kubernetes context, as well as a working Hello World! example. In that example, we chose kubebuilder as our framework to implement the Operator pattern.

Nevertheless, pretty much like everything else in the cloud native world, there are many, many more other implementation of the Operator pattern in the market, alongside kubebuilder. In this post, we will take a look at some of the most prominent ones, and in turn, provide an analysis for you, in hope that it will help you choose the most suitable one for your case, should you find it necessary to create a customized controller in future.

## Contenders for Kubernetes Operator

We hereby present the following six contenders to you in alphabetical orders:

- Juju, formerly known as Charmed Operator Framework
- kubebuilder
- KUDO, a.k.a. Kubernetes Universal Declarative Operator
- Metacontroller
- Operator Framework, specifically, the Operator SDK
- shell-operator

There are some other less significant players around that you are welcome to do your research on, but we will only discuss about these most prominent ones.

## A table

We have digested a table that will help in understanding and visualising features respectively.

NameOwner / Organisation behindStars on GitHubLanguage used to develop operatorsDifficulty to masterJujuCanonical1.9kPython, through **[Charmed Operator SDK](https://pythonoperatorframework.io/)** (Formerly aptly named Python Operator Framework)MediumKubebuilderkubernetes-sig4.3kGolangMediumKUDOCNCF0.9kN/A, i.e. You don’t need to write code!EasyMetacontrollerNot obvious, but started by Google243 (here) or ~800 (here)BYOD, can be js, python, go, java, etc…HardOperator FrameworkRedHat5kGolang/Ansible/HelmMedium - Hardshell-operatorFlant1.4kBash script, as well as your trusty utilities, such as jq, awk, and so on.Easy (if you are a shell script guru!)

## Remarks

## Juju

Owned by Canonical, the company behind Ubuntu Linux, Juju is actually much more than an operator SDK. Dubbed as a Charmed Operator Framework, Juju consists of three logical parts: a Charmed Operator Lifecycle Manager (OLM), the Charmed Operator SDK, and the Charmhub.

Charmed OLM is a manager that adds an abstraction layer on top of the pre-existing Kubernetes cluster, baremetal machines, or micro/monolith services, and integrate them into models. Fully utilising **[model-driven operation](https://juju.is/model-driven-operations-manifesto)**, it’s ideal if your workload spans across vastly different architecture.

Charmed Operator SDK then defines what each model consists, and how would each model corresponds and translates to underlying Kubernetes resources. Written in Python, this is ideal if you are familiar with the language. After the model (a charm) is defined, you will be able to distribute it on Charmhub. You will also find a very extensive collection of charms on Charmhub, from observability, to data, to identity, and a lot more.
