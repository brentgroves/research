# **[Process Capability Analysis Cp, Cpk, Pp, Ppk - A Guide](https://www.1factory.com/quality-academy/guide-process-capability.html)**

**[Python Process Capability Analysis (Cp & Cpk) | Normal Data](https://www.youtube.com/watch?v=YLn3YaMs4CQ)**

**[Python programs in process capability Cp, Cpk, PPM, sigma level](https://www.youtube.com/watch?v=-HFs7Sd73o4)**

## 01. What is Process Capability Analysis?

A process capability study uses data from an initial run of parts to predict whether a manufacturing process can repeatably produce parts that meet specifications.

Think of it as being similar to a forecast. You will take some historical data, and extrapolate out to the future to answer the question "can I rely on this process to deliver good parts?".

Your customers may require a process capability study as part of a PPAP. They will do this to ensure that your manufacturing processes are capable of consistently producing good parts.

PPAP most commonly refers to the Production Part Approval Process, a standardized system in the automotive and aerospace industries for verifying that a supplier can consistently produce parts that meet all customer specifications.

![i](https://www.1factory.com/assets/img/the-objective-of-process-capability-analysis-1factory.png)

## 02. The Basic Concept

When the manufacturing process is being defined, your goal is to ensure that the parts produced fall within the Upper and Lower Specification Limits (USL, LSL). Process Capability measures how consistently a manufacturing process can produce parts within specifications.

The basic idea is very simple. You want your manufacturing process to:

- (1) be centered over the Nominal desired by the design engineer, and
- (2) with a spread narrower than the specification width.

**Cp** measures whether the process spread is narrower than the specification width

**Cpk** measures both the centering of the process as well as the spread of the process relative to the specification width

![i](https://www.1factory.com/assets/img/visual-cp-cpk-1factory.png)

## 03. The Basic Calculations

Before we get into the detailed statistical calculations, let's review the high-level steps:

**1: Plot the Data:** Record the measurement data, and plot this data on a run-chart and on a histogram as shown in the picture on the right.

A run chart in statistical process control (SPC) is a line graph that displays data points over time, with a horizontal axis representing time and a vertical axis representing the measured variable. It typically includes a centerline at the median of the data to help identify trends, shifts, or patterns in a process.

A histogram in statistical process control (SPC) is a bar chart that visually represents the frequency distribution of numeric data from a process. It shows the shape, central location (like mean or median), and spread of the data, helping to determine if a process is stable and capable of meeting specifications. By showing where data points cluster, a histogram reveals the process's performance and variation over a specific period.

**2: Calculate the Spec Width:** Plot the Upper Spec Limit (USL) and Lower Spec Limit (LSL) on the histogram, and calculate the Spec Width as shown below.

Spec Width = USL — LSL

**3: Calculate the Process Width:** Similarly, we will also calculate the Process Width. The simplest way to think about the process width is "the difference between the largest value and the smallest value this process could create".

Process Width = UCL — LCL

**4: Calculate Cp:** Calculate the **capability index** as the ratio of the spec width to the process width.

Cp = Spec Width / Process Width

![i](https://www.1factory.com/assets/img/plot-the-data-histogram-run-chart-1factory.png)

## 04. A Simple Analogy

Imagine a driver trying to park a car in a garage. If the car is too wide, it won't fit. If it's narrower than the garage opening, but if it's not centered, it won't make it in - it will likely hit/scrape one of the sides. Hitting one of the sides of the garage is equivalent to producing a defective part.

But if the car is narrow enough AND well centered, the car will fit. That is our goal. We want a manufacturing process width that is narrow and well centered relative to the specification limits.

![i](https://www.1factory.com/assets/img/capable-vs-not-capable-1factory.png)

## 05. A More Realistic Analogy

Now let's assume that the car is the right width. It's narrow enough, and should always fit. It's now up to the driver's skill to park without scraping the sides. Imagine a driver arriving home after work each day, and parking his car in the garage.

**The Good Driver:** A good driver will always center the car well with enough room on both sides. Over the next 30 days, his run-chart and histogram will both be very narrow. It's clear from the charts that he's very unlikely to scrape or dent the car. There's plenty of room on either side.

**The Unsteady Driver:** On the other hand, an unsteady driver - someone learning to drive - may not always center the car correctly. Over the next 30 days, his run-chart and histogram are very wide. It's very likely that he could scrape or dent the car.

We'll use the same idea in manufacturing. We'll record measurements for each part made, then plot a histogram and run-chart, and see how much room we have on each side. The narrower our histogram width relative to the specification width, the higher our process capability.

Cp = Spec Width / Process Width
Cpk = distance from mean to the nearest spec limit/distance from mean to the process edge

![i](https://www.1factory.com/assets/img/analogy-interpreting-cp-cpk-1factory.png)

## 06. Collecting Data

Your measurements must follow the rules below:

**Gage Resolution:** Gages should be calibrated and gage resolution should be at least 1/10th the specification. E.g. 0.565 +/-0.005" implies a total tolerance of 0.010, and requires a gage with resolution 0.001" or smaller.
**Production Order:** To calculate Cpk, parts must be measured and recorded in production order. If parts are not recorded in production order, you may miss trends and periodic fluctuations.
**Record All Data:** Always record data for parts that pass, as well as for parts that fail.
**Ensure Traceability:** Make sure all measurements are traceable back to Man (Operator), Machine (Operation), Method, Material, Measurement System, and Environmental Conditions (5Ms, 1E) to enable process improvement. Record Unit Number or Serial Number for each part.
**Homogenous Data:** Keep data populations separate. A change in one of the 5M, 1E values may result in non-homogenous data. For example, do not mix the measurements made with two different types of equipment (e.g. CMM, caliper) into a single data-set.

The 5M 1E values refer to the six categories in a Ishikawa or fishbone diagram used for root cause analysis: Manpower, Machines, Materials, Methods, Measurements, and Environment. These values represent the different areas to investigate when trying to understand why a problem occurred. The "1E" stands for Environment, which is added to the standard "5M" categories to provide a more comprehensive analysis.

## 07. Process Stability

Before you begin a process capability analysis, you must check to ensure your process is stable. If your process is stable, the short-term behaviour of the process (during the initial run), will be a good predictor of the long-term behavior of the process (i.e. you can predict future performance with confidence).

Process behavior - both short-term and long-term - is characterized by the average and the standard deviation. A process will be considered stable when it's average and standard deviation are constant over time.

![i](https://www.1factory.com/assets/img/stable-and-unstable-process.png)

## NEXT 08. Short-Term & Long-Term Process Behaviour

For a stable process, the run chart should look relatively flat, without an upward or downward trend, and without periodic fluctuations.

Short-Term Standard Deviation:

To calculate short-term average and standard deviation, we create sub-groups of the data. Sub-groups can be created in two ways: you can either record consecutive measurements on an individuals chart and treat every two consecutive parts as a sub-group of size 2, or you can record measurements for 3 to 5 samples at a fixed interval (e.g. 5 parts every hour) on an x-bar chart.

The average and standard deviation of these sub-group measurements are called the short-term-average and short-term-standard-deviation or within-sub-group average and standard deviation.

Long-Term Standard Deviation:

Calculating long-term average and standard deviation is much simpler. We take all the measurements from the individuals charts, or from the x-bar charts, and calculate the average and standard deviation for the entire data-set.
