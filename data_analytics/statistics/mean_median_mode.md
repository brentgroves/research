# **[mean, median, mode](https://www.geeksforgeeks.org/maths/mean-median-mode/)**

Mean, median, and mode are key measures of central tendency in statistics, finding the "middle" or typical value of a dataset: the mean is the average (sum divided by count), the median is the exact middle number when data is ordered, and the mode is the most frequently occurring number; they each describe the center differently, with the mean sensitive to outliers, while the median and mode are more robust.  

Mean

- What it is: The arithmetic average.
- How to find: Add all the numbers in the dataset and then divide by the total count of numbers.
- Example: For {2, 3, 3, 4, 6}, (2+3+3+4+6) / 5 = 18 / 5 = 3.6.

Median

- What it is: The middle value in an ordered dataset.
- How to find: Arrange numbers from smallest to largest; if there's an odd count,  it's the center number; if even, it's the average of the two middle numbers.
- Example: For {1, 2, 4, 7, 9}, the median is 4.

Mode

- What it is: The number that appears most often.
- How to find: Count the occurrences of each number; the one with the highest count is the mode.
- Note: A dataset can have no mode, one mode, or multiple modes (bimodal, multimodal).
Example: In {5, 7, 8, 8, 3, 8, 4}, the mode is 8.

When to Use Each

- Use the mean for symmetrical data without extreme outliers.
- Use the median for skewed data or data with outliers (like house prices or salaries) because it's less affected by extreme values.
- Use the mode for categorical data (like favorite colors) or to find the most common item.

## **[standard deviation](https://www.khanacademy.org/math/statistics-probability/summarizing-quantitative-data/variance-standard-deviation-population/a/calculating-standard-deviation-step-by-step)**

To calculate standard deviation, first find the mean of your dataset. Then, for each data point, subtract the mean and square the result. Sum all of the squared differences, divide by the number of data points minus one (for a sample) or the total number of data points (for a population), and finally, take the square root of that number
