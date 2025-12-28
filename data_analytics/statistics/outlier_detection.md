# **[Outlier Detection — 3 Effective Methods Every Data Scientist Should Know](https://medium.com/data-science-collective/outlier-detection-made-simple-3-effective-methods-every-data-scientist-should-know-005fea304ddd)**

If you’re working with real data, you’re going to run into outliers. They’re the weird values that sit miles away from the rest.

Maybe a customer spent $10,000 when the average order is $50. Or a sensor glitched and logged -9999. These values distort your stats, especially the mean. And because so many decisions ride on means (A/B tests, pricing, forecasting, just to name a few), ignoring outliers can seriously mess with your results. The good news? You don’t need fancy math to deal with them. You just need to know a few simple strategies that actually work

Why Outliers Matter More Than You Think

Imagine you’re analyzing an experiment where the key metric is average order value. Say this metric usually follows a normal distribution. Now, suppose in the control group, the average is 10, while in the test group it’s 12. Both groups have a standard deviation of 3.

But both groups include outliers. These extreme values skew the mean and standard deviation, making the results less reliable.

Press enter or click to view image in full size

![i](https://miro.medium.com/v2/resize:fit:720/format:webp/0*4CLZ7z_iLXX5VkzS.jpeg)

This is how you can replicate this dataset:
