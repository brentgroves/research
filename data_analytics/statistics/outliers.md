# **[]()**

In statistics, an outlier is a data point that is significantly different from other observations in a dataset, lying an abnormal distance from the rest of the data. These extreme values can be caused by measurement errors, experimental issues, or represent a real but rare occurrence. Outliers can disproportionately influence statistical calculations, particularly the mean, so it's important to identify them and decide whether to remove them or investigate them further.

## Characteristics and identification

- **Definition:** An outlier is a value that is much higher or lower than the other data points.
- **Impact:** They can skew results, making the mean less representative of the data. For example, in the dataset (\(1,2,3,34\)), the mean is \(10\), but this is heavily influenced by the outlier \(34\)
- **Identification:** You can identify outliers visually by plotting the data on a number line, histogram, or scatterplot. A common statistical method is to identify points that fall outside the following range:

- **Lower Outlier:** Less than \(Q1-1.5(IQR)\)
- **Higher Outlier:** Greater than \(Q3+1.5(IQR)\)
- Where \(IQR=Q3-Q1\) is the Interquartile Range.

Examples could include measurements of the fill level of bottles filled at a bottling plant or the water temperature of a dishwashing machine each time it is run. Time is generally represented on the horizontal (x) axis and the property under observation on the vertical (y) axis. Often, some measure of central tendency (mean or median) of the data is indicated by a horizontal reference line.
