# **[statistical model](https://en.wikipedia.org/wiki/Statistical_model)**

A statistical model is a mathematical model that embodies a set of statistical assumptions concerning the generation of sample data (and similar data from a larger population). A statistical model represents, often in considerably idealized form, the data-generating process.[1] When referring specifically to probabilities, the corresponding term is probabilistic model. All statistical hypothesis tests and all statistical estimators are derived via statistical models. More generally, statistical models are part of the foundation of statistical inference. A statistical model is usually specified as a mathematical relationship between one or more random variables and other non-random variables. As such, a statistical model is "a formal representation of a theory" (Herman Adèr quoting Kenneth Bollen).[2]

Informally, a statistical model can be thought of as a statistical assumption (or set of statistical assumptions) with a certain property: that the assumption allows us to calculate the probability of any event. As an example, consider a pair of ordinary six-sided dice. We will study two different statistical assumptions about the dice.

The first statistical assumption is this: for each of the dice, the probability of each face (1, 2, 3, 4, 5, and 6) coming up is ⁠
1
/
6
⁠. From that assumption, we can calculate the probability of both dice coming up 5:  ⁠
1
/
6
⁠ × ⁠
1
/
6
⁠ = ⁠
1
/
36
⁠.  More generally, we can calculate the probability of any event: e.g. (1 and 2) or (3 and 3) or (5 and 6). The alternative statistical assumption is this: for each of the dice, the probability of the face 5 coming up is ⁠
1
/
8
⁠ (because the dice are weighted). From that assumption, we can calculate the probability of both dice coming up 5:  ⁠
1
/
8
⁠ × ⁠
1
/
8
⁠ = ⁠
1
/
64
⁠.  We cannot, however, calculate the probability of any other nontrivial event, as the probabilities of the other faces are unknown.

The first statistical assumption constitutes a statistical model: because with the assumption alone, we can calculate the probability of any event. The alternative statistical assumption does not constitute a statistical model: because with the assumption alone, we cannot calculate the probability of every event. In the example above, with the first assumption, calculating the probability of an event is easy. With some other examples, though, the calculation can be difficult, or even impractical (e.g. it might require millions of years of computation). For an assumption to constitute a statistical model, such difficulty is acceptable: doing the calculation does not need to be practicable, just theoretically possible.

In mathematical terms, a statistical model is a pair (
S
,
P
{\displaystyle S,{\mathcal {P}}}), where
S
{\displaystyle S} is the set of possible observations, i.e. the sample space, and
P
{\displaystyle {\mathcal {P}}} is a set of probability distributions on
S
{\displaystyle S}.[3] The set
P
{\displaystyle {\mathcal {P}}} represents all of the models that are considered possible. This set is typically parameterized:
P
=

{
F
θ
:
θ
∈
Θ
}
{\displaystyle {\mathcal {P}}=\{F_{\theta }:\theta \in \Theta \}}. The set
Θ
{\displaystyle \Theta } defines the parameters of the model. If a parameterization is such that distinct parameter values give rise to distinct distributions, i.e.
F
θ
1
=

F
θ
2
⇒
θ
1
=

θ
2
{\displaystyle F_{\theta _{1}}=F_{\theta_{2}}\Rightarrow \theta _{1}=\theta_{2}} (in other words, the mapping is injective), it is said to be identifiable.[3]

In some cases, the model can be more complex.

In Bayesian statistics, the model is extended by adding a probability distribution over the parameter space
Θ
{\displaystyle \Theta }.
A statistical model can sometimes distinguish two sets of probability distributions. The first set
Q
=

{
F
θ
:
θ
∈
Θ
}
{\displaystyle {\mathcal {Q}}=\{F_{\theta }:\theta \in \Theta \}} is the set of models considered for inference. The second set
P
=

{
F
λ
:
λ
∈
Λ
}
{\displaystyle {\mathcal {P}}=\{F_{\lambda }:\lambda \in \Lambda \}} is the set of models that could have generated the data which is much larger than
Q
{\displaystyle {\mathcal {Q}}}. Such statistical models are key in checking that a given procedure is robust, i.e. that it does not produce catastrophic errors when its assumptions about the data are incorrect.

An example
Suppose that we have a population of children, with the ages of the children distributed uniformly, in the population. The height of a child will be stochastically related to the age: e.g. when we know that a child is of age 7, this influences the chance of the child being 1.5 meters tall. We could formalize that relationship in a linear regression model, like this: heighti = b0 + b1agei + εi, where b0 is the intercept, b1 is a parameter that age is multiplied by to obtain a prediction of height, εi is the error term, and i identifies the child. This implies that height is predicted by age, with some error.

An admissible model must be consistent with all the data points. Thus, a straight line (heighti = b0 + b1agei) cannot be admissible for a model of the data—unless it exactly fits all the data points, i.e. all the data points lie perfectly on the line. The error term, εi, must be included in the equation, so that the model is consistent with all the data points. To do statistical inference, we would first need to assume some probability distributions for the εi. For instance, we might assume that the εi distributions are i.i.d. Gaussian, with zero mean. In this instance, the model would have 3 parameters: b0, b1, and the variance of the Gaussian distribution. We can formally specify the model in the form (
S
,
P
{\displaystyle S,{\mathcal {P}}}) as follows. The sample space,
S
{\displaystyle S}, of our model comprises the set of all possible pairs (age, height). Each possible value of
θ
{\displaystyle \theta } = (b0, b1, σ2) determines a distribution on
S
{\displaystyle S}; denote that distribution by
F
θ
{\displaystyle F_{\theta }}. If
Θ
{\displaystyle \Theta } is the set of all possible values of
θ
{\displaystyle \theta }, then
P
=

{
F
θ
:
θ
∈
Θ
}
{\displaystyle {\mathcal {P}}=\{F_{\theta }:\theta \in \Theta \}}. (The parameterization is identifiable, and this is easy to check.)

In this example, the model is determined by (1) specifying
S
{\displaystyle S} and (2) making some assumptions relevant to
P
{\displaystyle {\mathcal {P}}}. There are two assumptions: that height can be approximated by a linear function of age; that errors in the approximation are distributed as i.i.d. Gaussian. The assumptions are sufficient to specify
P
{\displaystyle {\mathcal {P}}}—as they are required to do.
